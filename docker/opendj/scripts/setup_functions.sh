#!/bin/bash

. ./setup_functions_varuables.sh

#set hostname
set_hostname(){
  export DJ_HOST=$(hostname -f)
}

##Initial install 
opendj_init() {
  "${OPENDJ_HOME}"/setup \
  "${TYPE}" \
  --rootUserDN "${ROOT_USER_DN}" \
  --rootUserPasswordFile "${ROOT_USER_PASSWORD_FILE}"  \
  --monitorUserDN "${MONITOR_USER_DN}"  \
  --monitorUserPasswordFile "${MONITOR_USER_PASSWORD_FILE}"  \
  --hostname "${DJ_HOST}"  \
  --ldapPort "${LDAP_PORT}"  \
  --ldapsPort "${LDAPS_PORT}"  \
  --adminConnectorPort "${ADMIN_PORT}"  \
  --baseDN "${BASE_DN}" \
  --ldifFile "${STRUCTURE}"  \
  --acceptLicense

  echo "Initial configuration is done!"
}

set_backend_prop(){
  "${OPENDJ_HOME}"/bin/dsconfig \
  set-backend-prop \
  --hostname "${DJ_HOST}" \
  --port "${ADMIN_PORT}" \
  --bindDN "${ROOT_USER_DN}" \
  --bindPasswordFile "${ROOT_USER_PASSWORD_FILE}" \
  --set db-cache-percent:"${DB_CACHE_PERCENT}" \
  --backend-name userRoot \
  --trustAll \
  --no-prompt

  echo "DB properties have been set!"
}


##Add global access control structure 
add_global_aci(){
  "${OPENDJ_HOME}"/bin/dsconfig \
  set-access-control-handler-prop  \
  --add global-aci:'(target = "ldap:///cn=schema")(targetattr = "attributeTypes || objectClasses")(version 3.0; acl "Modify schema"; allow (write) (userdn = "ldap:///uid=openam,ou=ServiceAccounts,dc=example,dc=com");)' \
  --hostname "${DJ_HOST}" \
  --port "${ADMIN_PORT}" \
  --bindDN "${ROOT_USER_DN}" \
  --bindPasswordFile "${ROOT_USER_PASSWORD_FILE}" \
  --trustAll \
  --no-prompt

  echo "global-aci has been added"
}

##Remove Anonymous access 
remove_anonymous_global_aci(){
  "${OPENDJ_HOME}"/bin/dsconfig \
  set-access-control-handler-prop  \
  --remove 'global-aci:(targetattr!="userPassword||authPassword||debugsearchindex||changes||changeNumber||changeType||changeTime||targetDN||newRDN||newSuperior||deleteOldRDN")(version 3.0; acl "Anonymous read access"; allow (read,search,compare) userdn="ldap:///anyone";)' \
  --remove 'global-aci:(targetattr="createTimestamp||creatorsName||modifiersName||modifyTimestamp||entryDN||entryUUID||subschemaSubentry||etag||governingStructureRule||structuralObjectClass||hasSubordinates||numSubordinates||isMemberOf")(version 3.0; acl "User-Visible Operational Attributes"; allow (read,search,compare) userdn="ldap:///anyone";)' \
  --add 'global-aci:(targetattr!="userPassword||authPassword||debugsearchindex||changes||changeNumber||changeType||changeTime||targetDN||newRDN||newSuperior||deleteOldRDN")(version 3.0; acl "Anonymous read access"; allow (read,search,compare) userdn="ldap:///all";)' \
  --add 'global-aci:(targetattr="createTimestamp||creatorsName||modifiersName||modifyTimestamp||entryDN||entryUUID||subschemaSubentry||etag||governingStructureRule||structuralObjectClass||hasSubordinates||numSubordinates||isMemberOf")(version 3.0; acl "User-Visible Operational Attributes"; allow (read,search,compare) userdn="ldap:///all";)' \
  --hostname "${DJ_HOST}" \
  --port "${ADMIN_PORT}" \
  --bindDN "${ROOT_USER_DN}" \
  --bindPasswordFile "${ROOT_USER_PASSWORD_FILE}" \
  --trustAll \
  --no-prompt

  echo "Anonymous access has been removed!"
}

##Remove Anonymous access OpenAM suggested 
remove_global_aci(){
  "${OPENDJ_HOME}"/bin/dsconfig \
  set-access-control-handler-prop  \
  --remove 'global-aci:(targetattr!="userPassword||authPassword||debugsearchindex||changes||changeNumber||changeType||changeTime||targetDN||newRDN||newSuperior||deleteOldRDN")(version 3.0; acl "Anonymous read access"; allow (read,search,compare) userdn="ldap:///anyone";)' \
  --hostname "${DJ_HOST}" \
  --port "${ADMIN_PORT}" \
  --bindDN "${ROOT_USER_DN}" \
  --bindPasswordFile "${ROOT_USER_PASSWORD_FILE}" \
  --trustAll \
  --no-prompt

  echo "Anonymous access has been removed!"
}

##Add schema definitions
add_schema(){
  local SCHEMA_FILE=$1

  "${OPENDJ_HOME}"/bin/ldapmodify \
  --hostname "${DJ_HOST}" \
  --port "${LDAP_PORT}" \
  --bindDN "${ROOT_USER_DN}" \
  --bindPasswordFile "${ROOT_USER_PASSWORD_FILE}" \
  "$SCHEMA_FILE"

  echo "$SCHEMA_FILE has been added!"
}

##Add global access control structure 
disable_virtual_attributes(){
  #local NAMES="collective-attribute-subentries entry-dn entry-uuid governing-structure-rule has-subordinates is-member-of num-subordinates password-expiration-time password-policy-subentry structural-object-class subschema-subentry"
  #VIRTUAL_ATTRIBUTES=("collective-attribute-subentries" "entryDn" "entryUuid" "governingStructureRule" "hasSubordinates" "isMemberOf" "numSubordinates" "password-expiration-time" "password-policy-subentry" "structuralObjectClass" "subschemaSubentry")
  #VIRTUAL_ATTRIBUTES=(entryDn" "entryUuid" "governingStructureRule" "hasSubordinates" "isMemberOf" "numSubordinates" "structuralObjectClass" "subschemaSubentry")
  VIRTUAL_ATTRIBUTES=("Collective Attribute Subentries" "entryDN" "entryUUID" "governingStructureRule" "hasSubordinates" "isMemberOf" "numSubordinates" "Password Expiration Time" "Password Policy Subentry" "structuralObjectClass" "subschemaSubentry")

  for NAME in $(seq 0 $((${#VIRTUAL_ATTRIBUTES[*]} - 1)))
  do
    "${OPENDJ_HOME}"/bin/dsconfig \
    set-virtual-attribute-prop  \
    --hostname "${DJ_HOST}" \
    --port "${ADMIN_PORT}" \
    --bindDN "${ROOT_USER_DN}" \
    --bindPasswordFile "${ROOT_USER_PASSWORD_FILE}" \
    --name="${VIRTUAL_ATTRIBUTES[$NAME]}" \
    --set enabled:false \
    --trustAll \
    --no-prompt

    echo "${VIRTUAL_ATTRIBUTES[$NAME]} has been disabled"
  done
}

restart_opendj(){
  "${OPENDJ_HOME}"/bin/stop-ds
  "${OPENDJ_HOME}"/bin/start-ds

  echo "DS server has been restarted!"
}

setup_ds_config_store() {
  set_common_variables
  set_ds_config_store_variables
  set_hostname
  opendj_init
  set_backend_prop
  remove_global_aci
  add_global_aci
  (add_schema ${SCHEMA})
  restart_opendj
}

setup_ds_cts_store() {
  #set_common_variables
  #set_ds_cts_store_variables
  set_hostname
  opendj_init
  set_backend_prop
  remove_global_aci
  add_global_aci
  (add_schema ${SCHEMA})
  (add_schema ${MULTIVALUE})
  (add_schema ${MULTIVALUE_INDICES})
  (add_schema ${INDICES})
  disable_virtual_attributes
  restart_opendj

}