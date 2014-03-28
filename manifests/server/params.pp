# == Class: icinga::server::params
#
# Parameters for the Icinga server.
#
# === Authors
#
# Nedap Steppingstone <steppingstone@nedap.com>
#
# === Copyright
#
# Copyright 2012, 2013 Nedap Steppingstone.
#
class icinga::server::params {
  case $::osfamily {
    'Debian': {
      $package_nrpe_plugin      = 'nagios-nrpe-plugin'
      $package_icinga           = 'icinga'
      $package_icinga_cgi       = 'icinga-cgi'
      $package_icinga_doc       = 'icinga-doc'
      $package_nagios_images    = 'nagios-images'
      $package_libjs_jquery_ui  = 'libjs-jquery-ui'
      $service_icinga           = 'icinga'
      $dir_icinga               = '/etc/icinga'
      $dir_nagios_plugins       = '/usr/lib/nagios/plugins'
      $dir_objects              = "${dir_icinga}/objects"
      $dir_modules              = "${dir_icinga}/modules"
      $dir_stylesheets          = "${dir_icinga}/stylesheets"
      $file_htpasswd            = "${dir_icinga}/htpasswd.users"
      $file_icingacfg           = "${dir_icinga}/icinga.cfg"
      $file_resourcecfg         = "${dir_icinga}/resource.cfg"
      $file_cgicfg              = "${dir_icinga}/cgi.cfg"
      $dir_htdocs               = '/usr/share/icinga/htdocs'
      $dir_cgi                  = '/usr/lib/cgi-bin/icinga'
      $dir_icinga_plugins       = '/usr/share/icinga/scripts'
      $dir_icinga_eventhandlers = '/usr/share/icinga/plugins/eventhandlers'
      $webserver_user           = 'www-data'
      $webserver_group          = 'www-data'
      $dir_icinga_log           = '/var/log/icinga'

      # following is used to configure icinga.cfg
      $dir_icinga_cache                            = '/var/cache/icinga'
      $icinga_logfile                              = "${dir_icinga_log}/icinga.log"
      $dir_nagios_plugins_config                   = '/etc/nagios-plugins/config'
      $object_cache_file                           = "${dir_icinga_cache}/objects.cache"
      $precached_object_file                       = "${dir_icinga_cache}/objects.precache"
      $status_file                                 = '/var/lib/icinga/status.dat'
      $status_update_interal                       = 10
      $icinga_user                                 = 'nagios'
      $icinga_group                                = 'nagios'
      $check_external_commands                     = 0
      $command_check_interval                      = -1
      # if you change the path of commnad_file change the paths in
      # icinga::server::configs exec's as well
      $command_file                                = '/var/lib/icinga/rw/icinga.cmd'
      $external_command_buffer_slots               = 32768
      $lock_file                                   = $::lsbdistcodename ? {
        'squeeze' => '/var/run/icinga/icinga.pid',
        'wheezy'  => '/run/icinga/icinga.pid',
        default   => '/run/icinga/icinga.pid',
      }
      $temp_file                                   = "${dir_icinga_cache}/icinga.tmp"
      $temp_path                                   = '/tmp'
      $event_broker_options                        = '-1'
      # default '/usr/lib/icinga/idomod.so config_file=/etc/icinga/idomod.cfg', but commented
      $broker_module                               = undef
      $log_rotation_method                         = 'd'
      $log_archive_path                            = "${dir_icinga_log}/archives"
      $use_daemon_log                              = 1
      $use_syslog                                  = 1
      $use_syslog_local_facility                   = 0
      $syslog_local_facility                       = 5
      $log_notifications                           = 1
      $log_service_retries                         = 1
      $log_host_retries                            = 1
      $log_event_handlers                          = 1
      $log_initial_states                          = 0
      $log_current_states                          = 1
      $log_external_commands                       = 1
      $log_passive_checks                          = 1
      $log_long_plugin_output                      = 0
      # default 'somecommand', but commented
      $global_host_event_handler                   = undef
      # default 'somecommand', but commented
      $global_service_event_handler                = undef
      $service_inter_check_delay_method            = 's'
      $max_service_check_spread                    = 30
      $service_interleave_factor                   = s
      $host_inter_check_delay_method               = s
      $max_host_check_spread                       = 30
      $max_concurrent_checks                       = 0
      $check_result_reaper_frequency               = 1
      $max_check_result_reaper_time                = 30
      $check_result_path                           = '/var/lib/icinga/spool/checkresults'
      $max_check_result_file_age                   = 3600
      # default 1024 but commented
      $max_check_result_list_items                 = undef
      $cached_host_check_horizon                   = 15
      $cached_service_check_horizon                = 15
      $enable_predictive_host_dependency_checks    = 1
      $enable_predictive_service_dependency_checks = 1
      $soft_state_dependencies                     = 0
      # default 900, but commented
      $time_change_threshold                       = undef
      $auto_reschedule_checks                      = 0
      $auto_rescheduling_interval                  = 30
      $auto_rescheduling_window                    = 180
      $sleep_time                                  = '0.25'
      $service_check_timeout                       = 60
      $host_check_timeout                          = 30
      $event_handler_timeout                       = 30
      $notification_timeout                        = 30
      $ocsp_timeout                                = 5
      $perfdata_timeout                            = 5
      $retain_state_information                    = 1
      $state_retention_file                        = "${dir_icinga_cache}/retention.dat"
      # default "${dir_icinga_cache}/sync.dat", but commented
      $sync_retention_file                         = undef
      $retention_update_interval                   = 60
      $use_retained_program_state                  = 1
      $use_retained_scheduling_info                = 1
      $retained_host_attribute_mask                = 0
      $retained_service_attribute_mask             = 0
      $retained_process_host_attribute_mask        = 0
      $retained_process_service_attribute_mask     = 0
      $retained_contact_host_attribute_mask        = 0
      $retained_contact_service_attribute_mask     = 0
      $interval_length                             = 60
      # the "check_for_updates" option and "bare_update_check" options are not
      # found anymore in Icinga 1.10+ version icinga.cfg files.
      # I'll leave them in for backwards compat.
      # I don't know default but icinga-core says "it does not support program update checking"
      $check_for_updates                           = undef
      # I don't know default but icinga-core says "it does not support program update checking"
      $bare_update_check                           = undef
      $use_aggressive_host_checking                = 0
      $execute_service_checks                      = 1
      $accept_passive_service_checks               = 1
      $execute_host_checks                         = 1
      $accept_passive_host_checks                  = 1
      $enable_event_handlers                       = 1
      $process_performance_data                    = 0
      # default 'process-host-perfdata', but commented
      $host_perfdata_command                       = undef
      # default 'process-service-perfdata', but commented
      $service_perfdata_command                    = undef
      # default '/tmp/host-perfdata', but commented
      $host_perfdata_file                          = undef
      # default '/tmp/service-perfdata', but commented
      $service_perfdata_file                       = undef
      # default '[HOSTPERFDATA]\t$TIMET$\t$HOSTNAME$\t$HOSTEXECUTIONTIME$\t$HOSTOUTPUT$\t$HOSTPERFDATA$', but commented
      $host_perfdata_file_template                 = undef
      # default '[SERVICEPERFDATA]\t$TIMET$\t$HOSTNAME$\t$SERVICEDESC$\t$SERVICEEXECUTIONTIME$\t$SERVICELATENCY$\t$SERVICEOUTPUT$\t$SERVICEPERFDATA$', but commented
      $service_perfdata_file_template              = undef
      # default 'a', but commented
      $host_perfdata_file_mode                     = undef
      # default 'a', but commented
      $service_perfdata_file_mode                  = undef
      # default 0, but commented
      $host_perfdata_file_processing_interval      = undef
      # default 0, but commented
      $service_perfdata_file_processing_interval   = undef
      # default 'process-host-perfdata-file', but commented
      $host_perfdata_file_processing_command       = undef
      # default 'process-service-perfdata-file', but commented
      $service_perfdata_file_processing_command    = undef
      # default 1, but commented
      $host_perfdata_process_empty_results         = undef
      # default 1, but commented
      $service_perfdata_process_empty_results      = undef
      # default 0, but commented
      $allow_empty_hostgroup_assignment            = undef
      $obsess_over_services                        = 0
      # default 'somecommand', but commented
      $ocsp_command                                = undef
      $obsess_over_hosts                           = 0
      # default 'somecommand', but commented
      $ochp_command                                = undef
      $translate_passive_host_checks               = 0
      $passive_host_checks_are_soft                = 0
      $check_for_orphaned_services                 = 1
      $check_for_orphaned_hosts                    = 1
      $service_check_timeout_state                 = u
      $check_service_freshness                     = 1
      $service_freshness_check_interval            = 60
      $check_host_freshness                        = 0
      $host_freshness_check_interval               = 60
      $additional_freshness_latency                = 15
      $enable_flap_detection                       = 1
      $low_service_flap_threshold                  = '5.0'
      $high_service_flap_threshold                 = '20.0'
      $low_host_flap_threshold                     = '5.0'
      $high_host_flap_threshold                    = '20.0'
      $date_format                                 = 'iso8601'
      # default not set
      $use_timezone                                = undef
      $p1_file                                     = '/usr/lib/icinga/p1.pl'
      $enable_embedded_perl                        = 0
      $use_embedded_perl_implicitly                = 1
      $stalking_event_handlers_for_hosts           = 0
      $stalking_event_handlers_for_services        = 0
      $stalking_notifications_for_hosts            = 0
      $stalking_notifications_for_services         = 0
      $illegal_object_name_chars                   = '`~!$%^&*|\'"<>?,()=:'
      $illegal_macro_output_chars                  = '`~$&|\'"<>'
      # I place a ' here to fix syntax highlight
      $use_regexp_matching                         = 0
      $use_true_regexp_matching                    = 0
      $admin_email                                 = 'root@localhost'
      $admin_pager                                 = 'pageroot@localhost'
      $daemon_dumps_core                           = 0
      $use_large_installation_tweaks               = 0
      $enable_environment_macros                   = 1
      # default 1, but commented
      $free_child_process_memory                   = undef
      # default 1, but commented
      $child_processes_fork_twice                  = undef
      $debug_level                                 = 0
      $debug_verbosity                             = 2
      $debug_file                                  = "${dir_icinga_log}/icinga.debug"
      $max_debug_file_size                         = 100000000
      # This is not deprecated in 1.9 and generates a warning in 1.10. Therefor
      # it will be undef (it originally was 0)
      $event_profiling_enabled                     = undef

      # Following is to configure cgi.cfg
      $main_config_file                                      = $file_icingacfg
      # default: /etc/icinga/cgiauth.cfg, but commented
      $authorization_config_file                             = undef
      $standalone_installation                               = 0
      $physical_html_path                                    = $dir_htdocs
      $url_html_path                                         = '/icinga'
      $url_stylesheets_path                                  = '/icinga/stylesheets'
      $http_charset                                          = 'utf-8'
      $show_context_help                                     = 0
      $highlight_table_rows                                  = 1
      $use_pending_states                                    = 1
      $use_logging                                           = 0
      $cgi_log_file                                          = "${dir_htdocs}/log/icinga-cgi.log"
      $cgi_log_rotation_method                               = d
      $cgi_log_archive_path                                  = "${dir_htdocs}/log"
      $enforce_comments_on_actions                           = 0
      $send_ack_notifications                                = 1
      $first_day_of_week                                     = 0
      $icinga_check_command                                  = "${dir_nagios_plugins}/check_nagios ${status_file} 5 '/usr/sbin/icinga'"
      $use_authentication                                    = 1
      $use_ssl_authentication                                = 0
      # default 'guest', but commented
      $default_user_name                                     = undef
      $authorized_for_system_information                     = 'icingaadmin'
      $authorized_contactgroup_for_system_information        = undef
      $authorized_for_configuration_information              = 'icingaadmin'
      $authorized_contactgroup_for_configuration_information = undef
      $authorized_for_full_command_resolution                = 'icingaadmin'
      $authorized_contactgroup_for_full_command_resolution   = undef
      $authorized_for_system_commands                        = 'icingaadmin'
      $authorized_contactgroup_for_system_commands           = undef
      $authorized_for_all_services                           = 'icingaadmin'
      $authorized_for_all_hosts                              = 'icingaadmin'
      $authorized_contactgroup_for_all_services              = undef
      $authorized_contactgroup_for_all_hosts                 = undef
      $authorized_for_all_service_commands                   = 'icingaadmin'
      $authorized_for_all_host_commands                      = 'icingaadmin'
      $authorized_contactgroup_for_all_service_commands      = undef
      $authorized_contactgroup_for_all_host_commands         = undef
      # default 'user1,user2', but commented
      $authorized_for_read_only                              = undef
      $authorized_contactgroup_for_read_only                 = undef
      $show_all_services_host_is_authorized_for              = 1
      $show_partial_hostgroups                               = 0
      # default 'smbackground.gd2', but commented
      $statusmap_background_image                            = undef
      # default 255, but commented
      $color_transparency_index_r                            = undef
      # default 255, but commented
      $color_transparency_index_g                            = undef
      # default 255, but commented
      $color_transparency_index_b                            = undef
      $default_statusmap_layout                              = 5
      $refresh_type                                          = 1
      $default_statuswrl_layout                              = 4
      $persistent_ack_comments                               = 0
      # default myworld.wrl, but commented
      $statuswrl_include                                     = undef
      $ping_syntax                                           = '/bin/ping -n -U -c 5 $HOSTADDRESS$'
      $refresh_rate                                          = 90
      $escape_html_tags                                      = 1
      $result_limit                                          = 50
      # default hostdown.wav, but commented
      $host_unreachable_sound                                = undef
      # default hostdown.wav, but commented
      $host_down_sound                                       = undef
      # default critical.wav, but commented
      $service_critical_sound                                = undef
      # default warning.wav, but commented
      $service_warning_sound                                 = undef
      # default warning.wav, but commented
      $service_unknown_sound                                 = undef
      # default noproblem.wav, but commented
      $normal_sound                                          = undef
      $action_url_target                                     = 'main'
      $notes_url_target                                      = 'main'
      $lock_author_names                                     = 1
      $default_downtime_duration                             = 7200
      $set_expire_ack_by_default                             = 0
      $default_expiring_acknowledgement_duration             = 86400
      $status_show_long_plugin_output                        = 0
      $display_status_totals                                 = 0
      $tac_show_only_hard_state                              = 0
      $extinfo_show_child_hosts                              = 0
      $suppress_maintenance_downtime                         = 0
      $show_tac_header                                       = 1
      $show_tac_header_pending                               = 1
      $exclude_customvar_name                                = 'PASSWORD,COMMUNITY'
      $exclude_customvar_value                               = 'secret'
      # default 0, but commented
      $showlog_initial_states                                = undef
      # default 0, but commented
      $showlog_current_states                                = undef
      # default 1000, but commented
      $default_num_displayed_log_entries                     = undef
      # default ';', but commented
      $csv_delimiter                                         = undef
      # default ', but commented
      $csv_data_enclosure                                    = undef
      # I place a ' here to fix syntax highlight
      $tab_friendly_titles                                   = 1
      # default 28, but commented
      $add_notif_num_hard                                    = undef
      # default 0, but commented
      $add_notif_num_soft                                    = undef
      # default 1, but commented
      $enable_splunk_integration                             = undef
      # default 'http://127.0.0.1:8000', but commented
      $splunk_url                                            = undef
      $resource_file                                         = $file_resourcecfg
      $log_file                                              = $icinga_logfile
    }
    default: {
      fail("\$osfamily ${::osfamily} is not supported by the Icinga module.")
    }
  }

  #ugly. needed because you can virtualize a resource multiple times but not export
  # the same resource multiple times.
  # So we need to create directories for each objecttype that icinga can have.
  # The reason to so is to avoid too long dirs (which works very slow in Linux)
  $object_dirs = [
    "${dir_objects}/command",
    "${dir_objects}/contact",
    "${dir_objects}/contactgroup",
    "${dir_objects}/host",
    "${dir_objects}/hostdependency",
    "${dir_objects}/hostescalation",
    "${dir_objects}/hostextinfo",
    "${dir_objects}/hostgroup",
    "${dir_objects}/module",
    "${dir_objects}/service",
    "${dir_objects}/servicedependency",
    "${dir_objects}/serviceescalation",
    "${dir_objects}/serviceextinfo",
    "${dir_objects}/servicegroup",
    "${dir_objects}/timeperiod",
  ]

}
