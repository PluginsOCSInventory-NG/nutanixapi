###############################################################################
## OCSINVENTORY-NG
## Copyleft Gilles Dubois 2020
## Web : http://www.ocsinventory-ng.org
##
## This code is open source and may be copied and modified as long as the source
## code is always made freely available.
## Please refer to the General Public Licence http://www.gnu.org/ or Licence.txt
################################################################################

package Ocsinventory::Agent::Modules::Nutanixapi;

# Use
use LWP::UserAgent;
use JSON;
use POSIX;

# Auth
my @auth_hashes = (
    {
       URL  => "http://an_awesome_nutanix_srv:9440/",  # http://an_awesome_nutanix_srv:9440/
       AUTH_DIG     => "BASIC_AUTH_TOKEN", # See HTTP Basic auth
    },
);

# API Endpoint list
my %nutanix_api_references = (
    "nutanix_vms_list" => "api/nutanix/v3/vms/list",
    "nutanix_hosts_list" => "api/nutanix/v3/hosts/list",
    "nutanix_clusters_list" => "api/nutanix/v3/clusters/list",
);

####### Create method ########
sub new {

   my $name="nutanixapi";   # Name of the module

   my (undef,$context) = @_;
   my $self = {};

   #Create a special logger for the module
   $self->{logger} = new Ocsinventory::Logger ({
            config => $context->{config}
   });

   $self->{logger}->{header}="[$name]";

   $self->{context}=$context;

   $self->{structure}= {
                        name => $name,
                        start_handler => undef,    #or undef if don't use this hook
                        prolog_writer => undef,    #or undef if don't use this hook
                        prolog_reader => undef,    #or undef if don't use this hook
                        inventory_handler => $name."_inventory_handler",    #or undef if don't use this hook
                        end_handler => undef    #or undef if don't use this hook
   };

   bless $self;
}

######### Hook methods ############
sub nutanixapi_inventory_handler {

    my $self = shift;
    my $logger = $self->{logger};

    my $common = $self->{context}->{common};

    # Debug log for inventory
    $logger->debug("Starting Nutanix inventory plugin");

    foreach (@auth_hashes){

        my $server_url = $_->{'URL'};
        my $auth_digest = $_->{'AUTH_DIG'};
        my $totalvm_number = 0;
        my $current_offset = 0;

        ##
        #   Clusters Inventory
        ##
        $logger->debug("Nutanix API Clusters inventory");

        $clusterlist_return = send_api_query($server_url, $nutanix_api_references{"nutanix_clusters_list"}, $auth_digest, $current_offset, "cluster");

        foreach (@{$clusterlist_return->{'entities'}}){
            # Logger
            $logger->debug("Starting nutanix infos retrival for cluster ".$_->{'metadata'}->{'uuid'});

            push @{$common->{xmltags}->{NUTANIXCLUSTER}},
            {
                CLUSTERUUID => [$_->{'metadata'}->{'uuid'}],
                CLUSTERSTATUS => [$_->{'status'}->{'state'}],
                CLUSTERNAME => [$_->{'status'}->{'name'}],
                CLUSTERENCRYPTION => [$_->{'status'}->{'resources'}->{'config'}->{'encryption_status'}],
                CLUSTERVERBOSITY => [$_->{'status'}->{'resources'}->{'config'}->{'supported_information_verbosity'}],
                CLUSTERRUNDFACTOR => [$_->{'status'}->{'resources'}->{'config'}->{'redundancy_factor'}],
                CLUSTERARCH => [$_->{'status'}->{'resources'}->{'config'}->{'cluster_arch'}],
                CLUSTERAVAILABLE => [manage_json_pp_bool($_->{'status'}->{'resources'}->{'config'}->{'is_available'})],
                CLUSTERBUILDTYPE => [$_->{'status'}->{'resources'}->{'config'}->{'build'}->{'build_type'}],
                CLUSTERBUILDVERSION => [$_->{'status'}->{'resources'}->{'config'}->{'build'}->{'version'}],
                CLUSTERBUILDLTS => [manage_json_pp_bool($_->{'status'}->{'resources'}->{'config'}->{'build'}->{'is_long_term_support'})],
                CLUSTERTZ => [$_->{'status'}->{'resources'}->{'config'}->{'timezone'}],
                CLUSTEREXTNET => [$_->{'status'}->{'resources'}->{'network'}->{'external_subnet'}],
                CLUSTERINTNET => [$_->{'status'}->{'resources'}->{'network'}->{'internal_subnet'}],
                CLUSTEREXTIP => [$_->{'status'}->{'resources'}->{'network'}->{'external_ip'}],
            };
        }

        ##
        #   Hosts Inventory
        ##
        $logger->debug("Nutanix API Hosts inventory");

        $hostlist_return = send_api_query($server_url, $nutanix_api_references{"nutanix_hosts_list"}, $auth_digest, $current_offset, "host");

        foreach (@{$hostlist_return->{'entities'}}){
            # Logger
            $logger->debug("Starting nutanix infos retrival for host ".$_->{'metadata'}->{'uuid'});

            push @{$common->{xmltags}->{NUTANIXHOST}},
            {
                HOSTUUID => [$_->{'metadata'}->{'uuid'}],
                HOSTSTATUS => [$_->{'status'}->{'state'}],
                HOSTNAME => [$_->{'status'}->{'name'}],
                HOSTCLUSTERN => [$_->{'status'}->{'cluster_reference'}->{'name'}],
                HOSTCLUSTERID => [$_->{'status'}->{'cluster_reference'}->{'uuid'}],
                HOSTSERIAL => [$_->{'status'}->{'resources'}->{'serial_number'}],
                HOSTIPMI => [$_->{'status'}->{'resources'}->{'ipmi'}->{'ip'}],
                HOSTTYPE => [$_->{'status'}->{'resources'}->{'host_type'}],
                HOSTCPU => [$_->{'status'}->{'resources'}->{'cpu_model'}],
                HOSTCPUSOCKET => [$_->{'status'}->{'resources'}->{'num_cpu_sockets'}],
                HOSTCPUNUM => [$_->{'status'}->{'resources'}->{'num_cpu_cores'}],
                HOSTMEMORY => [$_->{'status'}->{'resources'}->{'memory_capacity_mib'}],
                HOSTHVVMS => [$_->{'status'}->{'resources'}->{'hypervisor'}->{'num_vms'}],
                HOSTHVIP => [$_->{'status'}->{'resources'}->{'hypervisor'}->{'ip'}],
                HOSTHVNAME => [$_->{'status'}->{'resources'}->{'hypervisor'}->{'hypervisor_full_name'}],
            };
        }

        ##
        #   VMS Inventory
        ##
        $logger->debug("Nutanix API VMs inventory");

        $vmlist_return = send_api_query($server_url, $nutanix_api_references{"nutanix_vms_list"}, $auth_digest, $current_offset, "vm");

        if(exists $vmlist_return->{'metadata'}){
            $totalvm_number = $vmlist_return->{'metadata'}->{'total_matches'};
            # TODO: Manage if number superior to 500
            my $iteration_number;
            if($totalvm_number > 500){
                $iteration_number = ceil($totalvm_number / 500);
            }else{
                $iteration_number = 1;
            }

            $logger->debug("Nutanix API iteration number : ".$iteration_number);

            for (my $i = 1; $i <= $iteration_number; $i++) {

                $vmlist_return = send_api_query($server_url, $nutanix_api_references{"nutanix_vms_list"}, $auth_digest, $current_offset, "vm");

                foreach (@{$vmlist_return->{'entities'}}){

                    # VM UUID Retrival
                    my $vmuuid = $_->{'metadata'}->{'uuid'};

                    # Logger
                    $logger->debug("Starting nutanix infos retrival for vm ".$vmuuid);

                    my $os;
                    if(exists $_->{'status'}->{'resources'}->{'guest_tools'}->{'nutanix_guest_tools'}){
                        $os = $_->{'status'}->{'resources'}->{'guest_tools'}->{'nutanix_guest_tools'}->{'guest_os_version'};
                    }else{
                        $os = "Nutanix guest tools not installed";
                    }
                    push @{$common->{xmltags}->{NUTANIX}},
                    {
                        VMUUID => [$vmuuid],
                        VMSTATUS => [$_->{'status'}->{'state'}],
                        VMNAME => [$_->{'status'}->{'name'}],
                        VMDESC => [$_->{'status'}->{'description'}],
                        VMOS => [$os],
                        VMCLUSTER => [$_->{'status'}->{'cluster_reference'}->{'kind'}],
                        VMCLUSTERUUID => [$_->{'status'}->{'cluster_reference'}->{'uuid'}],
                        VMCLUSTERNAME => [$_->{'status'}->{'cluster_reference'}->{'name'}],
                    };

                    push @{$common->{xmltags}->{NUTANIXRESOURCES}},
                    {
                        VMUUID => [$vmuuid],
                        RESTHREAD => [$_->{'status'}->{'resources'}->{'num_threads_per_core'}],
                        RESVCPU => [$_->{'status'}->{'resources'}->{'num_vcpus_per_socket'}],
                        RESSOCKET => [$_->{'status'}->{'resources'}->{'num_sockets'}],
                        RESPROTECTED => [$_->{'status'}->{'resources'}->{'protection_type'}],
                        RESMEMORY => [$_->{'status'}->{'resources'}->{'memory_size_mib'}],
                        RESHWTIMEZONE => [$_->{'status'}->{'resources'}->{'hardware_clock_timezone'}],
                        RESPOWERSTATE => [$_->{'status'}->{'resources'}->{'power_state'}],
                        RESHYPERVISORTYPE => [$_->{'status'}->{'resources'}->{'hypervisor_type'}],
                    };

                    push @{$common->{xmltags}->{NUTANIXBOOT}},
                    {
                        VMUUID => [$vmuuid],
                        BOOTTYPE => [$_->{'status'}->{'resources'}->{'boot_config'}->{'boot_type'}],
                    };

                    foreach (@{$_->{'status'}->{'resources'}->{'disk_list'}}){
                        
                        push @{$common->{xmltags}->{NUTANIXDISK}},
                        {
                            VMUUID => [$vmuuid],
                            DISKUUID => [$_->{'uuid'}],
                            DISKTYPE => [$_->{'device_properties'}->{'device_type'}],
                            DISKADAPTER => [$_->{'device_properties'}->{'disk_address'}->{'adapter_type'}],
                            DISKKIND => [$_->{'data_source_reference'}->{'kind'}],
                            DISKSIZE => [$_->{'disk_size_bytes'}],
                            DISKSIZEMIB => [$_->{'disk_size_mib'}],
                        };

                    }

                    foreach (@{$_->{'status'}->{'resources'}->{'nic_list'}}){
                        
                        push @{$common->{xmltags}->{NUTANIXNIC}},
                        {
                            VMUUID => [$vmuuid],
                            NICTYPE => [$_->{'nic_type'}],
                            NICUUID => [$_->{'uuid'}],
                            NICVLANMODE => [$_->{'vlan_mode'}],
                            NICMACADDR => [$_->{'mac_address'}],
                            NICSUBNAME => [$_->{'subnet_reference'}->{'name'}],
                            NICACTIVE => [manage_json_pp_bool($_->{'is_connected'})],
                        };

                    }
                }

                $current_offset += 500;

            }

        }else{
            $logger->debug("Error while getting nutanix informations ".$vmlist_return);
        }

    }

}

sub manage_json_pp_bool{

  my $data_check;

  # Get passed arguments
  ($data_check) = @_;

  if ($data_check){
    return "true";
  }else{
    return "false";
  }

}

# Dev parse json file
sub parse_json_file
{
    my $filename = '/root/nutanix.json';

    my $json_text = do {
    open(my $json_fh, "<:encoding(UTF-8)", $filename)
        or die("Can't open \$filename\": $!\n");
    local $/;
    <$json_fh>
    };

    my $json = JSON->new;
    my $data = $json->decode($json_text);
}

# Query API to the nutanix server
sub send_api_query
{

    # Variables declaration
    my $lwp_useragent;
    my $server_endpoint;
    my $restpath;
    my $auth_dig;
    my $kind;
    my $req;
    my $resp;
    my $message;
    my $offset;

    # Get passed arguments
    ($server_endpoint, $restpath, $auth_dig, $offset, $kind) = @_;

    $lwp_useragent = LWP::UserAgent->new;

    # Header
    my $header = ['Authorization' => "Basic $auth_dig", 'Content-Type' => 'application/json; charset=UTF-8', 'Cache-Control' => 'no-cache'];

    my $post_data = {
        kind => $kind,
        length => 500,
        offset => $offset,
    };

    # set custom HTTP request header fields
    $req = HTTP::Request->new(
        'POST', 
        $server_endpoint . $restpath, 
        $header, 
        encode_json($post_data)
    );

    # Disable SSL Verify hostname
    $lwp_useragent->ssl_opts( verify_hostname => 0 ,SSL_verify_mode => 0x00);

    $resp = $lwp_useragent->request($req);
    if ($resp->is_success) {
        $message = $resp->decoded_content;
        return decode_json($message);
    }
    else {
        return $resp->message;
    }

}
