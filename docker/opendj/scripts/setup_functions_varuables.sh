#!/bin/bash
# Scripts needed only for spade, that need sudo

set_common_variables() {
  export HOSTNAME="opendj_cfg.roylab.com"
  export FILE_HOME="/Users/royb/Desktop/repo/identity-ds"
  export OPENDJ_HOME="/Users/royb/Desktop/repo/Environment/DS_cfg_store/opendj"
  export STRUCTURE="${FILE_HOME}/Artifacts/structure.ldif"
  export LDAP_PORT="1389"
  export LDAPS_PORT="1636"
  export ADMIN_PORT="4444"
  export DB_CACHE_PERCENT="70"
  export ROOT_USER_DN="cn=Directory Manager"
  export ROOT_USER_PASSWORD="Password1!"
  export ULTI_ADMIN_USER="UltiProAdmin"
  export ULTI_ADMIN_PASSWORD="Password1"
  export MONITOR_USER_DN="uid=Monitor"
  export MONITOR_USER_PASSWORD="Password2"
}


set_common_variables1() {
  export HOSTNAME="opendj_cts.roylab.com"
  export FILE_HOME="/Users/royb/Desktop/repo/identity-ds"
  export OPENDJ_HOME="/Users/royb/Desktop/repo/Environment/DS_cts_store/opendj"
  export STRUCTURE="${FILE_HOME}/cts_store/Artifacts/structure.ldif"
  export LDAP_PORT="2389"
  export LDAPS_PORT="2636"
  export ADMIN_PORT="5444"
  export DB_CACHE_PERCENT="70"
  export ROOT_USER_DN="cn=Directory Manager"
  export ROOT_USER_PASSWORD="Password1!"
  export ULTI_ADMIN_USER="UltiProAdmin"
  export ULTI_ADMIN_PASSWORD="Password1"
  export MONITOR_USER_DN="uid=Monitor"
  export MONITOR_USER_PASSWORD="Password2"
}

set_ds_config_store_variables() {
  export TYPE="directory-server"
  export BASE_DN="dc=ulti,dc=io"
  export SCHEMA="${FILE_HOME}/config_store/Artifacts/opendj_config_schema.ldif"
}

set_ds_cts_store_variables() {
  export TYPE="directory-server"
  export BASE_DN="dc=ulti,dc=io"
  export SCHEMA="${FILE_HOME}/cts_store/Artifacts/cts-add-schema.ldif"
  export MULTIVALUE="${FILE_HOME}/cts_store/Artifacts/cts-add-multivalue.ldif"
  export INDICES="${FILE_HOME}/cts_store/Artifacts/cts-indices.ldif"
  export MULTIVALUE_INDICES="${FILE_HOME}/cts_store/Artifacts/cts-add-multivalue-indices.ldif"
}




######
Qset_common_variables() {
  export DS_CFG_HOST="$(hostname -f)"
  export FILE_HOME="/opt/work"
  export OPENDJ_HOME="/opt/opendj"


  export STRUCTURE="${FILE_HOME}/Artifacts/structure.ldif"
  export LDAP_PORT="1389"
  export LDAPS_PORT="1636"
  export ADMIN_PORT="4444"
  export DB_CACHE_PERCENT="70"
  export ROOT_USER_DN="cn=Directory Manager"
  export ROOT_USER_PASSWORD="Password1!"
  export ULTI_ADMIN_USER="UltiProAdmin"
  export ULTI_ADMIN_PASSWORD="Password1"
  export MONITOR_USER_DN="uid=Monitor"
  export MONITOR_USER_PASSWORD="Password2"
}

Qset_ds_config_store_variables() {
  export TYPE="directory-server"
  export BASE_DN="dc=ulti,dc=io"
  export SCHEMA="${FILE_HOME}/Artifacts/opendj_config_schema.ldif"
}

