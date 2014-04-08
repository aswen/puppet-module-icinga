# == Class: icinga::server
#
# This will install the Icinga server including the webUI.
#
# === Parameters
#
# [*enable_notifications*]
#   _default_: +true+ from icinga
#   This tells the icingadaemon to annoy users or not
#
# [*icinga_configure_webserver*]
#   _default_: +false+
#   This enables the placement of a customized example config for your
#   webserver.
#   If you enable this you *must* also set icinga_vhostname
#
# [*icinga_webserver*]
#   _default_: +apache2+
#   Currently only apache2 and nginx are supported
#
# [*icinga_webserver_port*]
#   _default_: +9000+
#   Choose any free portnumber that this webservertemplate will listen to
#
# === Authors
#
# Nedap Stepping Stone <steppingstone@nedap.com>
#
# === Copyright
#
# Copyright 2012, 2013 Nedap Stepping Stone.
#
class icinga::server (
  $enable_notifications       = true,
  $icinga_configure_webserver = false,
  $icinga_vhostname           = '',
  $icinga_webserver           = 'apache2',
  $icinga_webserver_port      = 9000,
  $dir_webserver_log          = $::icinga::server::params::dir_icinga_log,

  $package_nrpe_plugin      = $::icinga::server::params::package_nrpe_plugin,
  $package_icinga           = $::icinga::server::params::package_icinga,
  $package_icinga_cgi       = $::icinga::server::params::package_icinga_cgi,
  $package_icinga_doc       = $::icinga::server::params::package_icinga_doc,
  $package_nagios_images    = $::icinga::server::params::package_nagios_images,
  $package_libjs_jquery_ui  = $::icinga::server::params::package_libjs_jquery_ui,
  $service_icinga           = $::icinga::server::params::service_icinga,
  $dir_icinga               = $::icinga::server::params::dir_icinga,
  $dir_nagios_plugins       = $::icinga::server::params::dir_nagios_plugins,
  $dir_objects              = $::icinga::server::params::dir_objects,
  $dir_modules              = $::icinga::server::params::dir_modules,
  $dir_stylesheets          = $::icinga::server::params::dir_stylesheets,
  $file_htpasswd            = $::icinga::server::params::file_htpasswd,
  $file_icingacfg           = $::icinga::server::params::file_icingacfg,
  $file_resourcecfg         = $::icinga::server::params::file_resourcecfg,
  $file_cgicfg              = $::icinga::server::params::file_cgicfg,
  $dir_htdocs               = $::icinga::server::params::dir_htdocs,
  $dir_cgi                  = $::icinga::server::params::dir_cgi,
  $dir_icinga_plugins       = $::icinga::server::params::dir_icinga_plugins,
  $dir_icinga_eventhandlers = $::icinga::server::params::dir_icinga_eventhandlers,
  $object_dirs              = $::icinga::server::params::object_dirs,
  $webserver_user           = $::icinga::server::params::webserver_user,
  $webserver_group          = $::icinga::server::params::webserver_group,


  # icinga.cfg
  $icinga_logfile                              = $::icinga::server::params::icinga_logfile,
  $dir_nagios_plugins_config                   = $::icinga::server::params::dir_nagios_plugins_config,
  $object_cache_file                           = $::icinga::server::params::object_cache_file,
  $precached_object_file                       = $::icinga::server::params::precached_object_file,
  $status_file                                 = $::icinga::server::params::status_file,
  $status_update_interval                      = $::icinga::server::params::status_update_interval,
  $icinga_user                                 = $::icinga::server::params::icinga_user,
  $icinga_group                                = $::icinga::server::params::icinga_group,
  $check_external_commands                     = $::icinga::server::params::check_external_commands,
  $command_check_interval                      = $::icinga::server::params::command_check_interval,
  $command_file                                = $::icinga::server::params::command_file,
  $external_command_buffer_slots               = $::icinga::server::params::external_command_buffer_slots,
  $lock_file                                   = $::icinga::server::params::lock_file,
  $temp_file                                   = $::icinga::server::params::temp_file,
  $temp_path                                   = $::icinga::server::params::temp_path,
  $event_broker_options                        = $::icinga::server::params::event_broker_options,
  $broker_module                               = $::icinga::server::params::broker_module,
  $log_rotation_method                         = $::icinga::server::params::log_rotation_method,
  $log_archive_path                            = $::icinga::server::params::log_archive_path,
  $use_daemon_log                              = $::icinga::server::params::use_daemon_log,
  $use_syslog                                  = $::icinga::server::params::use_syslog,
  $use_syslog_local_facility                   = $::icinga::server::params::use_syslog_local_facility,
  $syslog_local_facility                       = $::icinga::server::params::syslog_local_facility,
  $log_notifications                           = $::icinga::server::params::log_notifications,
  $log_service_retries                         = $::icinga::server::params::log_service_retries,
  $log_host_retries                            = $::icinga::server::params::log_host_retries,
  $log_event_handlers                          = $::icinga::server::params::log_event_handlers,
  $log_initial_states                          = $::icinga::server::params::log_initial_states,
  $log_current_states                          = $::icinga::server::params::log_current_states,
  $log_external_commands                       = $::icinga::server::params::log_external_commands,
  $log_passive_checks                          = $::icinga::server::params::log_passive_checks,
  $log_long_plugin_output                      = $::icinga::server::params::log_long_plugin_output,
  $global_host_event_handler                   = $::icinga::server::params::global_host_event_handler,
  $global_service_event_handler                = $::icinga::server::params::global_service_event_handler,
  $service_inter_check_delay_method            = $::icinga::server::params::service_inter_check_delay_method,
  $max_service_check_spread                    = $::icinga::server::params::max_service_check_spread,
  $service_interleave_factor                   = $::icinga::server::params::service_interleave_factor,
  $host_inter_check_delay_method               = $::icinga::server::params::host_inter_check_delay_method,
  $max_host_check_spread                       = $::icinga::server::params::max_host_check_spread,
  $max_concurrent_checks                       = $::icinga::server::params::max_concurrent_checks,
  $check_result_reaper_frequency               = $::icinga::server::params::check_result_reaper_frequency,
  $max_check_result_reaper_time                = $::icinga::server::params::max_check_result_reaper_time,
  $check_result_path                           = $::icinga::server::params::check_result_path,
  $max_check_result_file_age                   = $::icinga::server::params::max_check_result_file_age,
  $max_check_result_list_items                 = $::icinga::server::params::max_check_result_list_items,
  $cached_host_check_horizon                   = $::icinga::server::params::cached_host_check_horizon,
  $cached_service_check_horizon                = $::icinga::server::params::cached_service_check_horizon,
  $enable_predictive_host_dependency_checks    = $::icinga::server::params::enable_predictive_host_dependency_checks,
  $enable_predictive_service_dependency_checks = $::icinga::server::params::enable_predictive_service_dependency_checks,
  $soft_state_dependencies                     = $::icinga::server::params::soft_state_dependencies,
  $time_change_threshold                       = $::icinga::server::params::time_change_threshold,
  $auto_reschedule_checks                      = $::icinga::server::params::auto_reschedule_checks,
  $auto_rescheduling_interval                  = $::icinga::server::params::auto_rescheduling_interval,
  $auto_rescheduling_window                    = $::icinga::server::params::auto_rescheduling_window,
  $sleep_time                                  = $::icinga::server::params::sleep_time,
  $service_check_timeout                       = $::icinga::server::params::service_check_timeout,
  $host_check_timeout                          = $::icinga::server::params::host_check_timeout,
  $event_handler_timeout                       = $::icinga::server::params::event_handler_timeout,
  $notification_timeout                        = $::icinga::server::params::notification_timeout,
  $ocsp_timeout                                = $::icinga::server::params::ocsp_timeout,
  $perfdata_timeout                            = $::icinga::server::params::perfdata_timeout,
  $retain_state_information                    = $::icinga::server::params::retain_state_information,
  $state_retention_file                        = $::icinga::server::params::state_retention_file,
  $sync_retention_file                         = $::icinga::server::params::sync_retention_file,
  $retention_update_interval                   = $::icinga::server::params::retention_update_interval,
  $use_retained_program_state                  = $::icinga::server::params::use_retained_program_state,
  $use_retained_scheduling_info                = $::icinga::server::params::use_retained_scheduling_info,
  $retained_host_attribute_mask                = $::icinga::server::params::retained_host_attribute_mask,
  $retained_service_attribute_mask             = $::icinga::server::params::retained_service_attribute_mask,
  $retained_process_host_attribute_mask        = $::icinga::server::params::retained_process_host_attribute_mask,
  $retained_process_service_attribute_mask     = $::icinga::server::params::retained_process_service_attribute_mask,
  $retained_contact_host_attribute_mask        = $::icinga::server::params::retained_contact_host_attribute_mask,
  $retained_contact_service_attribute_mask     = $::icinga::server::params::retained_contact_service_attribute_mask,
  $interval_length                             = $::icinga::server::params::interval_length,
  $check_for_updates                           = $::icinga::server::params::check_for_updates,
  $bare_update_check                           = $::icinga::server::params::bare_update_check,
  $use_aggressive_host_checking                = $::icinga::server::params::use_aggressive_host_checking,
  $execute_service_checks                      = $::icinga::server::params::execute_service_checks,
  $accept_passive_service_checks               = $::icinga::server::params::accept_passive_service_checks,
  $execute_host_checks                         = $::icinga::server::params::execute_host_checks,
  $accept_passive_host_checks                  = $::icinga::server::params::accept_passive_host_checks,
  $enable_event_handlers                       = $::icinga::server::params::enable_event_handlers,
  $process_performance_data                    = $::icinga::server::params::process_performance_data,
  $host_perfdata_command                       = $::icinga::server::params::host_perfdata_command,
  $service_perfdata_command                    = $::icinga::server::params::service_perfdata_command,
  $host_perfdata_file                          = $::icinga::server::params::host_perfdata_file,
  $service_perfdata_file                       = $::icinga::server::params::service_perfdata_file,
  $host_perfdata_file_template                 = $::icinga::server::params::host_perfdata_file_template,
  $service_perfdata_file_template              = $::icinga::server::params::service_perfdata_file_template,
  $host_perfdata_file_mode                     = $::icinga::server::params::host_perfdata_file_mode,
  $service_perfdata_file_mode                  = $::icinga::server::params::service_perfdata_file_mode,
  $host_perfdata_file_processing_interval      = $::icinga::server::params::host_perfdata_file_processing_interval,
  $service_perfdata_file_processing_interval   = $::icinga::server::params::service_perfdata_file_processing_interval,
  $host_perfdata_file_processing_command       = $::icinga::server::params::host_perfdata_file_processing_command,
  $service_perfdata_file_processing_command    = $::icinga::server::params::service_perfdata_file_processing_command,
  $host_perfdata_process_empty_results         = $::icinga::server::params::host_perfdata_process_empty_results,
  $service_perfdata_process_empty_results      = $::icinga::server::params::service_perfdata_process_empty_results,
  $allow_empty_hostgroup_assignment            = $::icinga::server::params::allow_empty_hostgroup_assignment,
  $obsess_over_services                        = $::icinga::server::params::obsess_over_services,
  $ocsp_command                                = $::icinga::server::params::ocsp_command,
  $obsess_over_hosts                           = $::icinga::server::params::obsess_over_hosts,
  $ochp_command                                = $::icinga::server::params::ochp_command,
  $translate_passive_host_checks               = $::icinga::server::params::translate_passive_host_checks,
  $passive_host_checks_are_soft                = $::icinga::server::params::passive_host_checks_are_soft,
  $check_for_orphaned_services                 = $::icinga::server::params::check_for_orphaned_services,
  $check_for_orphaned_hosts                    = $::icinga::server::params::check_for_orphaned_hosts,
  $service_check_timeout_state                 = $::icinga::server::params::service_check_timeout_state,
  $check_service_freshness                     = $::icinga::server::params::check_service_freshness,
  $service_freshness_check_interval            = $::icinga::server::params::service_freshness_check_interval,
  $check_host_freshness                        = $::icinga::server::params::check_host_freshness,
  $host_freshness_check_interval               = $::icinga::server::params::host_freshness_check_interval,
  $additional_freshness_latency                = $::icinga::server::params::additional_freshness_latency,
  $enable_flap_detection                       = $::icinga::server::params::enable_flap_detection,
  $low_service_flap_threshold                  = $::icinga::server::params::low_service_flap_threshold,
  $high_service_flap_threshold                 = $::icinga::server::params::high_service_flap_threshold,
  $low_host_flap_threshold                     = $::icinga::server::params::low_host_flap_threshold,
  $high_host_flap_threshold                    = $::icinga::server::params::high_host_flap_threshold,
  $date_format                                 = $::icinga::server::params::date_format,
  $p1_file                                     = $::icinga::server::params::p1_file,
  $enable_embedded_perl                        = $::icinga::server::params::enable_embedded_perl,
  $use_embedded_perl_implicitly                = $::icinga::server::params::use_embedded_perl_implicitly,
  $stalking_event_handlers_for_hosts           = $::icinga::server::params::stalking_event_handlers_for_hosts,
  $stalking_event_handlers_for_services        = $::icinga::server::params::stalking_event_handlers_for_services,
  $stalking_notifications_for_hosts            = $::icinga::server::params::stalking_notifications_for_hosts,
  $stalking_notifications_for_services         = $::icinga::server::params::stalking_notifications_for_services,
  $illegal_object_name_chars                   = $::icinga::server::params::illegal_object_name_chars,
  $illegal_macro_output_chars                  = $::icinga::server::params::illegal_macro_output_chars,
  $use_regexp_matching                         = $::icinga::server::params::use_regexp_matching,
  $use_true_regexp_matching                    = $::icinga::server::params::use_true_regexp_matching,
  $admin_email                                 = $::icinga::server::params::admin_email,
  $admin_pager                                 = $::icinga::server::params::admin_pager,
  $daemon_dumps_core                           = $::icinga::server::params::daemon_dumps_core,
  $use_large_installation_tweaks               = $::icinga::server::params::use_large_installation_tweaks,
  $enable_environment_macros                   = $::icinga::server::params::enable_environment_macros,
  $free_child_process_memory                   = $::icinga::server::params::free_child_process_memory,
  $child_processes_fork_twice                  = $::icinga::server::params::child_processes_fork_twice,
  $debug_level                                 = $::icinga::server::params::debug_level,
  $debug_verbosity                             = $::icinga::server::params::debug_verbosity,
  $debug_file                                  = $::icinga::server::params::debug_file,
  $max_debug_file_size                         = $::icinga::server::params::max_debug_file_size,
  # This is not deprecated in 1.9 and generates a warning in 1.10. Therefor
  # it will be undef (it originally was 0)
  $event_profiling_enabled                     = $::icinga::server::params::event_profiling_enabled,

  # Following is to configure cgi.cfg
  $main_config_file                                      = $::icinga::server::params::main_config_file,
  $authorization_config_file                             = $::icinga::server::params::authorization_config_file,
  $standalone_installation                               = $::icinga::server::params::standalone_installation,
  $physical_html_path                                    = $::icinga::server::params::physical_html_path,
  $url_html_path                                         = $::icinga::server::params::url_html_path,
  $url_stylesheets_path                                  = $::icinga::server::params::url_stylesheets_path,
  $http_charset                                          = $::icinga::server::params::http_charset,
  $show_context_help                                     = $::icinga::server::params::show_context_help,
  $highlight_table_rows                                  = $::icinga::server::params::highlight_table_rows,
  $use_pending_states                                    = $::icinga::server::params::use_pending_states,
  $use_logging                                           = $::icinga::server::params::use_logging,
  $cgi_log_file                                          = $::icinga::server::params::cgi_log_file,
  $cgi_log_rotation_method                               = $::icinga::server::params::cgi_log_rotation_method,
  $cgi_log_archive_path                                  = $::icinga::server::params::cgi_log_archive_path,
  $enforce_comments_on_actions                           = $::icinga::server::params::enforce_comments_on_actions,
  $send_ack_notifications                                = $::icinga::server::params::send_ack_notifications,
  $first_day_of_week                                     = $::icinga::server::params::first_day_of_week,
  $icinga_check_command                                  = $::icinga::server::params::icinga_check_command,
  $use_authentication                                    = $::icinga::server::params::use_authentication,
  $use_ssl_authentication                                = $::icinga::server::params::use_ssl_authentication,
  $default_user_name                                     = $::icinga::server::params::default_user_name,
  $authorized_for_system_information                     = $::icinga::server::params::authorized_for_system_information,
  $authorized_contactgroup_for_system_information        = $::icinga::server::params::authorized_contactgroup_for_system_information,
  $authorized_for_configuration_information              = $::icinga::server::params::authorized_for_configuration_information,
  $authorized_contactgroup_for_configuration_information = $::icinga::server::params::authorized_contactgroup_for_configuration_information,
  $authorized_for_full_command_resolution                = $::icinga::server::params::authorized_for_full_command_resolution,
  $authorized_contactgroup_for_full_command_resolution   = $::icinga::server::params::authorized_contactgroup_for_full_command_resolution,
  $authorized_for_system_commands                        = $::icinga::server::params::authorized_for_system_commands,
  $authorized_contactgroup_for_system_commands           = $::icinga::server::params::authorized_contactgroup_for_system_commands,
  $authorized_for_all_services                           = $::icinga::server::params::authorized_for_all_services,
  $authorized_for_all_hosts                              = $::icinga::server::params::authorized_for_all_hosts,
  $authorized_contactgroup_for_all_services              = $::icinga::server::params::authorized_contactgroup_for_all_services,
  $authorized_contactgroup_for_all_hosts                 = $::icinga::server::params::authorized_contactgroup_for_all_hosts,
  $authorized_for_all_service_commands                   = $::icinga::server::params::authorized_for_all_service_commands,
  $authorized_for_all_host_commands                      = $::icinga::server::params::authorized_for_all_host_commands,
  $authorized_contactgroup_for_all_service_commands      = $::icinga::server::params::authorized_contactgroup_for_all_service_commands,
  $authorized_contactgroup_for_all_host_commands         = $::icinga::server::params::authorized_contactgroup_for_all_host_commands,
  $authorized_for_read_only                              = $::icinga::server::params::authorized_for_read_only,
  $authorized_contactgroup_for_read_only                 = $::icinga::server::params::authorized_contactgroup_for_read_only,
  $show_all_services_host_is_authorized_for              = $::icinga::server::params::show_all_services_host_is_authorized_for,
  $show_partial_hostgroups                               = $::icinga::server::params::show_partial_hostgroups,
  $statusmap_background_image                            = $::icinga::server::params::statusmap_background_image,
  $color_transparency_index_r                            = $::icinga::server::params::color_transparency_index_r,
  $color_transparency_index_g                            = $::icinga::server::params::color_transparency_index_g,
  $color_transparency_index_b                            = $::icinga::server::params::color_transparency_index_b,
  $default_statusmap_layout                              = $::icinga::server::params::default_statusmap_layout,
  $refresh_type                                          = $::icinga::server::params::refresh_type,
  $default_statuswrl_layout                              = $::icinga::server::params::default_statuswrl_layout,
  $persistent_ack_comments                               = $::icinga::server::params::persistent_ack_comments,
  $statuswrl_include                                     = $::icinga::server::params::statuswrl_include,
  $ping_syntax                                           = $::icinga::server::params::ping_syntax,
  $refresh_rate                                          = $::icinga::server::params::refresh_rate,
  $escape_html_tags                                      = $::icinga::server::params::escape_html_tags,
  $result_limit                                          = $::icinga::server::params::result_limit,
  $host_unreachable_sound                                = $::icinga::server::params::host_unreachable_sound,
  $host_down_sound                                       = $::icinga::server::params::host_down_sound,
  $service_critical_sound                                = $::icinga::server::params::service_critical_sound,
  $service_warning_sound                                 = $::icinga::server::params::service_warning_sound,
  $service_unknown_sound                                 = $::icinga::server::params::service_unknown_sound,
  $normal_sound                                          = $::icinga::server::params::normal_sound,
  $action_url_target                                     = $::icinga::server::params::action_url_target,
  $notes_url_target                                      = $::icinga::server::params::notes_url_target,
  $lock_author_names                                     = $::icinga::server::params::lock_author_names,
  $default_downtime_duration                             = $::icinga::server::params::default_downtime_duration,
  $set_expire_ack_by_default                             = $::icinga::server::params::set_expire_ack_by_default,
  $default_expiring_acknowledgement_duration             = $::icinga::server::params::default_expiring_acknowledgement_duration,
  $status_show_long_plugin_output                        = $::icinga::server::params::status_show_long_plugin_output,
  $display_status_totals                                 = $::icinga::server::params::display_status_totals,
  $tac_show_only_hard_state                              = $::icinga::server::params::tac_show_only_hard_state,
  $extinfo_show_child_hosts                              = $::icinga::server::params::extinfo_show_child_hosts,
  $suppress_maintenance_downtime                         = $::icinga::server::params::suppress_maintenance_downtime,
  $show_tac_header                                       = $::icinga::server::params::show_tac_header,
  $show_tac_header_pending                               = $::icinga::server::params::show_tac_header_pending,
  $exclude_customvar_name                                = $::icinga::server::params::exclude_customvar_name,
  $exclude_customvar_value                               = $::icinga::server::params::exclude_customvar_value,
  $showlog_initial_states                                = $::icinga::server::params::showlog_initial_states,
  $showlog_current_states                                = $::icinga::server::params::showlog_current_states,
  $default_num_displayed_log_entries                     = $::icinga::server::params::default_num_displayed_log_entries,
  $csv_delimiter                                         = $::icinga::server::params::csv_delimiter,
  $csv_data_enclosure                                    = $::icinga::server::params::csv_data_enclosure,
  $tab_friendly_titles                                   = $::icinga::server::params::tab_friendly_titles,
  $add_notif_num_hard                                    = $::icinga::server::params::add_notif_num_hard,
  $add_notif_num_soft                                    = $::icinga::server::params::add_notif_num_soft,
  $enable_splunk_integration                             = $::icinga::server::params::enable_splunk_integration,
  $splunk_url                                            = $::icinga::server::params::splunk_url,
  $resource_file                                         = $::icinga::server::params::resource_file,
  $log_file                                              = $::icinga::server::params::log_file,
) inherits icinga::server::params {

  validate_bool($enable_notifications)
  validate_bool($icinga_configure_webserver)

  if $icinga_configure_webserver {
    validate_string($icinga_vhostname)
    if empty($icinga_vhostname) {
      fail('You should tell me the hostname to configure.')
    }
    validate_string($icinga_webserver)
    if $icinga_webserver !~ /apache|nginx/ {
      fail('There are only default configs for Apache and Nginx.')
    }
    if ! is_integer($icinga_webserver_port) {
      fail('icinga_webserver_port must be an integer.')
    }
  }

  class { '::icinga::server::users': } ->
  class { '::icinga::server::packages': } ->
  class { '::icinga::server::configs': } ->
  class { '::icinga::server::services': } ->
  Class [ '::icinga::server' ]

}
