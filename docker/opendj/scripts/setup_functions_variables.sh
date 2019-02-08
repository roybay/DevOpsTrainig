#!/bin/bash
# Scripts needed only for spade, that need sudo

set_common_variables() {
  export HOSTNAME="$(hostname -f)"
  export FILE_HOME="/opt/bits"
  export OPENDJ_HOME="/opt/opendj"
  export STRUCTURE="${FILE_HOME}/Artifacts/structure.ldif"
  export LDAP_PORT="1389"
  export LDAPS_PORT="1636"
  export ADMIN_PORT="4444"
  export DB_CACHE_PERCENT="70"
  export ROOT_USER_DN="cn=Directory Manager"
  export ROOT_USER_PASSWORD_FILE="${FILE_HOME}/Artifacts/.pw_root_user"
  export ADMIN_USER="AdminUser"
  export ADMIN_PASSWORD_FILE="${FILE_HOME}/Artifacts/.pw_admin_user"
  export MONITOR_USER_DN="uid=Monitor"
  export MONITOR_USER_PASSWORD_FILE="${FILE_HOME}/Artifacts/.pw_monitor_user"
}

set_ds_config_store_variables() {
  export TYPE="directory-server"
  export BASE_DN="dc=roylab,dc=com"
  export SCHEMA="${FILE_HOME}/Artifacts/opendj_config_schema.ldif"
}

set_ds_cts_store_variables() {
  export TYPE="directory-server"
  export BASE_DN="dc=roylab,dc=com"
  export SCHEMA="${FILE_HOME}/cts_store/Artifacts/cts-add-schema.ldif"
  export MULTIVALUE="${FILE_HOME}/cts_store/Artifacts/cts-add-multivalue.ldif"
  export INDICES="${FILE_HOME}/cts_store/Artifacts/cts-indices.ldif"
  export MULTIVALUE_INDICES="${FILE_HOME}/cts_store/Artifacts/cts-add-multivalue-indices.ldif"
}
