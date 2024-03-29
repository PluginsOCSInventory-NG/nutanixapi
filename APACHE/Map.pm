###############################################################################
## OCSINVENTORY-NG
## Copyright OCS Inventory team
## Web : http://www.ocsinventory-ng.org
##
## This code is open source and may be copied and modified as long as the source
## code is always made freely available.
## Please refer to the General Public Licence http://www.gnu.org/ or Licence.txt
################################################################################
 
package Apache::Ocsinventory::Plugins::Nutanix::Map;
 
use strict;
 
use Apache::Ocsinventory::Map;

$DATA_MAP{nutanix} = {
	mask => 0,
	multi => 1,
	auto => 1,
	delOnReplace => 1,
	sortBy => 'VMNAME',
	writeDiff => 0,
	cache => 0,
	fields => {
	VMUUID => {},
	VMSTATUS => {},
	VMNAME => {},
	VMDESC => {},
	VMOS => {},
	VMPOWERSTATE => {},
	VMCLUSTER => {},
	VMCLUSTERUUID => {},
	VMCLUSTERNAME => {}
	}
};

$DATA_MAP{nutanixresources} = {
	mask => 0,
	multi => 1,
	auto => 1,
	delOnReplace => 1,
	sortBy => 'VMUUID',
	writeDiff => 0,
	cache => 0,
	fields => {
	VMUUID => {},
	RESTHREAD => {},
	RESVCPU => {},
	RESSOCKET => {},
	RESPROTECTED => {},
	RESMEMORY => {},
	RESHWTIMEZONE => {},
	RESHYPERVISORTYPE => {}
	}
};

$DATA_MAP{nutanixboot} = {
	mask => 0,
	multi => 1,
	auto => 1,
	delOnReplace => 1,
	sortBy => 'VMUUID',
	writeDiff => 0,
	cache => 0,
	fields => {
	VMUUID => {},
	BOOTTYPE => {}
	}
};

$DATA_MAP{nutanixdisk} = {
	mask => 0,
	multi => 1,
	auto => 1,
	delOnReplace => 1,
	sortBy => 'VMUUID',
	writeDiff => 0,
	cache => 0,
	fields => {
	VMUUID => {},
	DISKUUID => {},
	DISKTYPE => {},
	DISKADAPTER => {},
	DISKKIND => {},
	DISKSIZE => {},
	DISKSIZEMIB => {}
	}
};

$DATA_MAP{nutanixnic} = {
	mask => 0,
	multi => 1,
	auto => 1,
	delOnReplace => 1,
	sortBy => 'VMUUID',
	writeDiff => 0,
	cache => 0,
	fields => {
	VMUUID => {},
	NICTYPE => {},
	NICUUID => {},
	NICVLANMODE => {},
	NICMACADDR => {},
	NICSUBNAME => {},
	NICACTIVE => {}
	}
};

$DATA_MAP{nutanixhost} = {
	mask => 0,
	multi => 1,
	auto => 1,
	delOnReplace => 1,
	sortBy => 'HOSTUUID',
	writeDiff => 0,
	cache => 0,
	fields => {
	NUTANIXSRVURL => {},
	HOSTUUID => {},
	HOSTSTATUS => {},
	HOSTNAME => {},
	HOSTCLUSTERN => {},
	HOSTCLUSTERID => {},
	HOSTSERIAL => {},
	HOSTIPMI => {},
	HOSTTYPE => {},
	HOSTCPU => {},
	HOSTCPUSOCKET => {},
	HOSTCPUNUM => {},
	HOSTMEMORY => {},
	HOSTHVVMS => {},
	HOSTHVIP => {},
	HOSTHVNAME => {}
	}
};

$DATA_MAP{nutanixcluster} = {
	mask => 0,
	multi => 1,
	auto => 1,
	delOnReplace => 1,
	sortBy => 'CLUSTERUUID',
	writeDiff => 0,
	cache => 0,
	fields => {
	NUTANIXSRVURL => {},
	CLUSTERUUID => {},
	CLUSTERSTATUS => {},
	CLUSTERNAME => {},
	CLUSTERENCRYPTION => {},
	CLUSTERVERBOSITY => {},
	CLUSTERRUNDFACTOR => {},
	CLUSTERARCH => {},
	CLUSTERAVAILABLE => {},
	CLUSTERBUILDTYPE => {},
	CLUSTERBUILDVERSION => {},
	CLUSTERBUILDLTS => {},
	CLUSTERTZ => {},
	CLUSTEREXTNET => {},
	CLUSTERINTNET => {},
	CLUSTEREXTIP => {}
	}
};

1;
