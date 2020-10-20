<?php
//====================================================================================
// OCS INVENTORY REPORTS
// Copyleft GILLES DUBOIS 2020 (erwan(at)ocsinventory-ng(pt)org)
// Web: http://www.ocsinventory-ng.org
//
// This code is open source and may be copied and modified as long as the source
// code is always made freely available.
// Please refer to the General Public Licence http://www.gnu.org/ or Licence.txt
//====================================================================================
 
	if(AJAX){
		parse_str($protectedPost['ocs']['0'], $params);
		$protectedPost+=$params;
		ob_start();
		$ajax = true;
	}
	else{
		$ajax=false;
    }

    require "require/function_machine.php";
    
    print_item_header($l->g(37000));
    
    if(!isset($protectedGet['details'])){
        if (!isset($protectedPost['SHOW']))
		    $protectedPost['SHOW'] = 'NOSHOW';
        
        $form_name="nutanix";
        $table_name=$form_name;
        $tab_options=$protectedPost;
        $tab_options['form_name']=$form_name;
        $tab_options['table_name']=$table_name;

        //definition of onglet
        $def_onglets['VMS'] = $l->g(37060);
        $def_onglets['HOSTS'] = $l->g(37061); 
        $def_onglets['CLUSTERS'] = $l->g(37062); 

        //default => first onglet
        if ($protectedPost['onglet'] == "") {
            $protectedPost['onglet'] = "VMS";
        }

        echo open_form($form_name);

        //show first ligne of onglet
        show_tabs($def_onglets,$form_name,"onglet",true);

        echo '<div class="col col-md-10">';

        if($protectedPost['onglet'] == "VMS"){
            $list_fields=array(
                $l->g(1268) => "VMUUID",
                $l->g(81) => "VMSTATUS",
                $l->g(49) => "VMNAME",
                $l->g(53) => "VMDESC",
                $l->g(25) => "VMOS",
                $l->g(37001) => "VMCLUSTER",
                $l->g(37002) => "VMCLUSTERUUID",
                $l->g(37003) => "VMCLUSTERNAME",
            );
            
            $tab_options['LIEN_LBL'][$l->g(49)] = 'index.php?' . PAG_INDEX . '=ms_nutanix&details=';
            $tab_options['LIEN_CHAMP'][$l->g(49)] = 'VMUUID';

            $sql['SQL'] = 'SELECT * FROM nutanix';
        }

        if($protectedPost['onglet'] == "HOSTS"){
            $list_fields=array(
                $l->g(1268) => "HOSTUUID",
                $l->g(81) => "HOSTSTATUS",
                $l->g(49) => "HOSTNAME",
                $l->g(37003) => "HOSTCLUSTERN",
                $l->g(37002) => "HOSTCLUSTERID",
                $l->g(36) => "HOSTSERIAL",
                $l->g(37030) => "HOSTIPMI",
                $l->g(66) => "HOSTTYPE",
                $l->g(350) => "HOSTCPU",
                $l->g(351) => "HOSTCPUSOCKET",
                $l->g(1317) => "HOSTCPUNUM",
                $l->g(26) => "HOSTMEMORY",
                $l->g(37031) => "HOSTHVVMS",
                $l->g(37032) => "HOSTHVIP",
                $l->g(37033) => "HOSTHVNAME",
            );

            $sql['SQL'] = 'SELECT * FROM nutanixhost';
        }

        if($protectedPost['onglet'] == "CLUSTERS"){
            $list_fields=array(
                $l->g(1268) => "CLUSTERUUID",
                $l->g(81) => "CLUSTERSTATUS",
                $l->g(49) => "CLUSTERNAME",
                $l->g(37040) => "CLUSTERENCRYPTION",
                $l->g(37041) => "CLUSTERVERBOSITY",
                $l->g(37042) => "CLUSTERRUNDFACTOR",
                $l->g(1247) => "CLUSTERARCH",
                $l->g(37043) => "CLUSTERAVAILABLE",
                $l->g(37044) => "CLUSTERBUILDTYPE",
                $l->g(37045) => "CLUSTERBUILDVERSION",
                $l->g(37046) => "CLUSTERBUILDLTS",
                $l->g(37047) => "CLUSTERTZ",
                $l->g(37048) => "CLUSTEREXTNET",
                $l->g(37049) => "CLUSTERINTNET",
                $l->g(37050) => "CLUSTEREXTIP",
            );

            $sql['SQL'] = 'SELECT * FROM nutanixcluster';
        }

        $list_col_cant_del=$list_fields;
        $default_fields= $list_fields;
        
        ajaxtab_entete_fixe($list_fields,$default_fields,$tab_options,$list_col_cant_del);

        echo "</div>";
        echo close_form();
    }else{
        //form name
        $form_name = 'nutanix_details';
        //form open
        echo open_form($form_name, '', '', 'form-horizontal');

        $table_name=$form_name;
        $tab_options=$protectedPost;
        $tab_options['form_name']=$form_name;
        $tab_options['table_name']=$table_name;

        //definition of onglet
        $def_onglets['RESOURCES'] = $l->g(37005);
        $def_onglets['BOOT'] = $l->g(37004); 
        $def_onglets['NIC'] = $l->g(82); 
        $def_onglets['DISK'] = $l->g(92); 

        //default => first onglet
        if ($protectedPost['onglet'] == "") {
            $protectedPost['onglet'] = "RESOURCES";
        }

        //show first ligne of onglet
        show_tabs($def_onglets,$form_name,"onglet",true);

        echo '<div class="col col-md-10">';

        /******************************* RESOURCES *******************************/
        if($protectedPost['onglet'] == "RESOURCES"){

            $sql['SQL'] = 'SELECT * FROM nutanixresources WHERE VMUUID = "%s"';
            $sql['ARG'] = [$protectedGet['details']];

            $list_fields = array(
                $l->g(1268) => 'VMUUID',
                $l->g(37006) => 'RESTHREAD',
                $l->g(37007) => 'RESVCPU',
                $l->g(37008) => 'RESSOCKET',
                $l->g(37009) => 'RESPROTECTED',
                $l->g(37010) => 'RESMEMORY',
                $l->g(37011) => 'RESHWTIMEZONE',
                $l->g(37012) => 'RESPOWERSTATE',
                $l->g(37013) => 'RESHYPERVISORTYPE',
            );
        }

        /******************************* BOOT *******************************/
        if($protectedPost['onglet'] == "BOOT"){

            $sql['SQL'] = 'SELECT * FROM nutanixboot WHERE VMUUID = "%s"';
            $sql['ARG'] = [$protectedGet['details']];

            $list_fields = array(
                $l->g(1268) => 'VMUUID',
                $l->g(37014) => 'BOOTTYPE',
            );

        }

        /******************************* NETWORKS *******************************/
        if($protectedPost['onglet'] == "NIC"){

            $sql['SQL'] = 'SELECT * FROM nutanixnic WHERE VMUUID = "%s"';
            $sql['ARG'] = [$protectedGet['details']];

            $list_fields = array(
                $l->g(1268) => 'VMUUID',
                $l->g(37015) => 'NICTYPE',
                $l->g(37016) => 'NICUUID',
                $l->g(37017) => 'NICVLANMODE',
                $l->g(37018) => 'NICMACADDR',
                $l->g(37019) => 'NICSUBNAME',
                $l->g(37020) => 'NICACTIVE',
            );
        }

        /******************************* DISK *******************************/
        if($protectedPost['onglet'] == "DISK"){

            $sql['SQL'] = 'SELECT * FROM nutanixdisk WHERE VMUUID = "%s"';
            $sql['ARG'] = [$protectedGet['details']];

            $list_fields = array(
                $l->g(1268) => 'VMUUID',
                $l->g(37021) => 'DISKUUID',
                $l->g(37022) => 'DISKTYPE',
                $l->g(37023) => 'DISKADAPTER',
                $l->g(37024) => 'DISKKIND',
                $l->g(37025) => 'DISKSIZE',
                $l->g(37026) => 'DISKSIZEMIB',
            );

        }

        $default_fields = $list_fields;
        $list_col_cant_del = $default_fields;
        $tab_options['ARG_SQL'] = $sql['ARG'];

        $result_exist = ajaxtab_entete_fixe($list_fields, $default_fields, $tab_options, $list_col_cant_del);

        echo "</div>";
        echo close_form();
    }

    if ($ajax){
		ob_end_clean();
		tab_req($list_fields,$default_fields,$list_col_cant_del,$sql['SQL'],$tab_options);
		ob_start();
	}
?>