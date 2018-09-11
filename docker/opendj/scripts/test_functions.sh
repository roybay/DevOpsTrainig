#!/bin/bash

. ../scripts/setup_functions_spade.sh

RED='\033[1;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

#Root suffix is dc=ulti,dc=io
get_root_suffix() {
	"${OPENDJ_HOME}"/bin/ldapsearch \
	--hostname "${HOSTNAME}" \
	--port "${LDAP_PORT}" \
	--bindDN "${ROOT_USER_DN}" \
	--bindPasswordFile "${ROOT_USER_FILE}" \
	--baseDn "ds-cfg-backend-id=userRoot,cn=Backends,cn=config" \
	--searchScope base objectclass=top ds-cfg-base-dn
}

#Config data dc=openam,dc=ulti,dc=io
get_config_data() {
	"${OPENDJ_HOME}"/bin/ldapsearch \
	--hostname "${HOSTNAME}" \
	--port "${LDAP_PORT}" \
	--bindDN "${ROOT_USER_DN}" \
	--bindPasswordFile "${ROOT_USER_FILE}" \
	--baseDn "dc=openam,dc=ulti,dc=io" \
	--searchScope base objectclass=top
}

#OpenAM access  
get_openam_access() {
	"${OPENDJ_HOME}"/bin/ldapsearch \
	--hostname "${HOSTNAME}" \
	--port "${LDAP_PORT}" \
	--bindDN "${ROOT_USER_DN}" \
	--bindPasswordFile "${ROOT_USER_FILE}" \
	--baseDn "dc=ulti,dc=io" \
	--searchScope base objectclass=top aci | grep uid=openam
}

#servie account suffix 
get_serviceaccounts_suffix() {
	"${OPENDJ_HOME}"/bin/ldapsearch \
	--hostname "${HOSTNAME}" \
	--port "${LDAP_PORT}" \
	--bindDN "${ROOT_USER_DN}" \
	--bindPasswordFile "${ROOT_USER_FILE}" \
	--baseDn "ou=ServiceAccounts,dc=ulti,dc=io" \
	--searchScope base objectclass=top dn
}

#openam privileges
get_openam_privileges() {
	"${OPENDJ_HOME}"/bin/ldapsearch \
	--hostname "${HOSTNAME}" \
	--port "${LDAP_PORT}" \
	--bindDN "${ROOT_USER_DN}" \
	--bindPasswordFile "${ROOT_USER_FILE}" \
	--baseDn "uid=openam,ou=ServiceAccounts,dc=ulti,dc=io" \
	--searchScope base objectclass=top ds-privilege-name ds-rlim-size-limit ds-rlim-lookthrough-limit
}

#CTS schema
get_cts_schema() {
	"${OPENDJ_HOME}"/bin/ldapsearch \
	--hostname "${HOSTNAME}" \
	--port "${LDAP_PORT}" \
	--bindDN "${ROOT_USER_DN}" \
	--bindPasswordFile "${ROOT_USER_FILE}" \
	--baseDn "cn=schema" \
	--searchScope base objectclass=top objectclasses | grep -e "1.3.6.1.4.1.36733.2.2.2.27"
}

#Config schema
get_config_schema() {
	"${OPENDJ_HOME}"/bin/ldapsearch \
	--hostname "${HOSTNAME}" \
	--port "${LDAP_PORT}" \
	--bindDN "${ROOT_USER_DN}" \
	--bindPasswordFile "${ROOT_USER_FILE}" \
	--baseDn "cn=schema" \
	--searchScope base objectclass=top objectclasses | grep -e "1.3.6.1.4.1.42.2.27.9.2.25" -e "1.3.6.1.4.1.42.2.27.9.2.104" -e "1.3.6.1.4.1.42.2.27.9.2.27"
}

#Verify OpenAM allowed to modify schema
get_modify_schema() {
	"${OPENDJ_HOME}"/bin/ldapsearch \
	--hostname "${HOSTNAME}" \
	--port "${LDAP_PORT}" \
	--bindDN "${ROOT_USER_DN}" \
	--bindPasswordFile "${ROOT_USER_FILE}" \
	--baseDn "cn=Access Control Handler,cn=config" objectclass=top | grep cn=schema | grep uid=openam
}

#verify HTTP port 
get_https_connection_port() {
	"${OPENDJ_HOME}"/bin/ldapsearch \
	--hostname "${HOSTNAME}" \
	--port "${LDAP_PORT}" \
	--bindDN "${ROOT_USER_DN}" \
	--bindPasswordFile "${ROOT_USER_FILE}" \
	--baseDn " cn=HTTPS,cn=connection handlers,cn=config" objectclass=top ds-cfg-enabled
}

#Config schema
get_cache_size() {
	"${OPENDJ_HOME}"/bin/ldapsearch \
	--hostname "${HOSTNAME}" \
	--port "${LDAP_PORT}" \
	--bindDN "${ROOT_USER_DN}" \
	--bindPasswordFile "${ROOT_USER_FILE}" \
	--baseDn "ds-cfg-backend-id=userRoot,cn=Backends,cn=config" \
	--searchScope base objectclass=top ds-cfg-db-cache-percent
}

#Restric anonymous access
get_anonymous_access() {
	"${OPENDJ_HOME}"/bin/ldapsearch \
	--hostname "${HOSTNAME}" \
	--port "${LDAP_PORT}" \
	--bindDN "${ROOT_USER_DN}" \
	--bindPasswordFile "${ROOT_USER_FILE}" \
	--baseDn "cn=Access Control Handler,cn=config" objectclass=top | grep -i anyone
}

get_virtual_attribute(){
	VIRTUAL_ATTRIBUTE=$1

	"${OPENDJ_HOME}"/bin/dsconfig \
	get-virtual-attribute-prop  \
	--hostname "${HOSTNAME}" \
	--port "${ADMIN_PORT}" \
	--bindDN "${ROOT_USER_DN}" \
	--bindPasswordFile "${ROOT_USER_FILE}" \
	--name="${VIRTUAL_ATTRIBUTE}" \
 	--trustAll \
	--no-prompt | grep "enabled"
}


test_root_suffix(){
	CURRENT_VALUE=$(get_root_suffix)
	EXPECTED_VALUE="dn: ds-cfg-backend-id=userRoot,cn=Backends,cn=config
ds-cfg-base-dn: dc=ulti,dc=io"

	if [[ "$CURRENT_VALUE" == "$EXPECTED_VALUE" ]]
	then
		printf "root_suffix ${GREEN}Success! ${NC}as expected\n"
	else
		printf "root_suffix ${RED}FAILED! ${NC} NOT expected\n"
		printf "Current value is/are:\n$CURRENT_VALUE\n\n"
		printf "Expected value is/are:\n$EXPECTED_VALUE\n" 
		exit 1
	fi
}

test_config_data(){
	CURRENT_VALUE=$(get_config_data)
	EXPECTED_VALUE="dn: dc=openam,dc=ulti,dc=io
objectClass: top
objectClass: domain
dc: openam"
	 
	if [[ "$CURRENT_VALUE" == "$EXPECTED_VALUE" ]]
	then
		printf "config data has been created ${GREEN}Successfully! ${NC}as expected\n"
	else
		printf "Config data has been ${RED}FAILED! ${NC} NOT expected\n"
		printf "Current value is/are:\n$CURRENT_VALUE\n\n"
		printf "Expected value is/are:\n$EXPECTED_VALUE\n" 
		exit 1
	fi
}

test_openam_access(){
	CURRENT_VALUE=$(get_openam_access)
	EXPECTED_VALUE='aci: (targetattr="*")(version 3.0;acl "Allow CRUDQ operations";allow (search, read, write, add, delete)(userdn = "ldap:///uid=openam,ou=ServiceAccounts,dc=ulti,dc=io");)
aci: (targetcontrol="2.16.840.1.113730.3.4.3")(version 3.0;acl "Allow persistent search"; allow (search, read)(userdn = "ldap:///uid=openam,ou=ServiceAccounts,dc=ulti,dc=io");)
aci: (targetcontrol="1.2.840.113556.1.4.473")(version 3.0;acl "Allow server-side sorting"; allow (read)(userdn = "ldap:///uid=openam,ou=ServiceAccounts,dc=ulti,dc=io");)'
	
	if [[ "$CURRENT_VALUE" == "$EXPECTED_VALUE" ]]
	then
		printf "OpenAM access has been granted ${GREEN}Successfully! ${NC}as expected\n"
	else
		printf "OpenAM access has been ${RED}FAILED! ${NC} NOT expected\n"
		printf "Current value is/are:\n$CURRENT_VALUE\n\n"
		printf "Expected value is/are:\n$EXPECTED_VALUE\n" 
		exit 1
	fi
}

test_serviceaccounts_suffix(){
	CURRENT_VALUE=$(get_serviceaccounts_suffix)
	EXPECTED_VALUE="dn: ou=ServiceAccounts,dc=ulti,dc=io"
	 
	if [[ "$CURRENT_VALUE" == "$EXPECTED_VALUE" ]]
	then
		printf "ServiceAccounts suffix has been created ${GREEN}Successfully! ${NC}as expected\n"
	else
		printf "ServiceAccounts suffix has been ${RED}FAILED! ${NC} NOT expected\n"
		printf "Current value is/are:\n$CURRENT_VALUE\n\n"
		printf "Expected value is/are:\n$EXPECTED_VALUE\n" 
		exit 1
	fi
}

test_openam_privileges(){
	CURRENT_VALUE=$(get_openam_privileges)
	EXPECTED_VALUE="dn: uid=openam,ou=ServiceAccounts,dc=ulti,dc=io
ds-privilege-name: subentry-write
ds-privilege-name: update-schema
ds-rlim-size-limit: 0
ds-rlim-lookthrough-limit: 0"
	 
	if [[ "$CURRENT_VALUE" == "$EXPECTED_VALUE" ]]
	then
		printf "OpenAM privileges has been granted ${GREEN}Successfully! ${NC}as expected\n"
	else
		printf "OpenAM privileges has been ${RED}FAILED! ${NC} NOT expected\n"
		printf "Current value is/are:\n$CURRENT_VALUE\n\n"
		printf "Expected value is/are:\n$EXPECTED_VALUE\n" 
		exit 1
	fi
}

test_cts_schema(){
	CURRENT_VALUE=$(get_cts_schema)
	EXPECTED_VALUE="objectclasses: ( 1.3.6.1.4.1.36733.2.2.2.27 NAME 'frCoreToken' DESC 'object containing ForgeRock Core Token' SUP top STRUCTURAL MUST ( coreTokenId $ coreTokenType ) MAY ( coreTokenExpirationDate $ coreTokenUserId $ coreTokenObject $ coreTokenString01 $ coreTokenString02 $ coreTokenString03 $ coreTokenString04 $ coreTokenString05 $ coreTokenString06 $ coreTokenString07 $ coreTokenString08 $ coreTokenString09 $ coreTokenString10 $ coreTokenString11 $ coreTokenString12 $ coreTokenString13 $ coreTokenString14 $ coreTokenString15 $ coreTokenInteger01 $ coreTokenInteger02 $ coreTokenInteger03 $ coreTokenInteger04 $ coreTokenInteger05 $ coreTokenInteger06 $ coreTokenInteger07 $ coreTokenInteger08 $ coreTokenInteger09 $ coreTokenInteger10 $ coreTokenDate01 $ coreTokenDate02 $ coreTokenDate03 $ coreTokenDate04 $ coreTokenDate05 $ coreTokenMultiString01 $ coreTokenMultiString02 $ coreTokenMultiString03 ) X-ORIGIN 'ForgeRock OpenAM CTSv2' X-SCHEMA-FILE '99-user.ldif' )"
	 
	if [[ "$CURRENT_VALUE" == "$EXPECTED_VALUE" ]]
	then
		printf "CTS schema has been applied ${GREEN}Successfully! ${NC}as expected\n"
	else
		printf "CTS schema has been ${RED}FAILED! ${NC} NOT expected\n"
		printf "Current value is/are:\n$CURRENT_VALUE\n\n"
		printf "Expected value is/are:\n$EXPECTED_VALUE\n" 
		exit 1
	fi
}

test_config_schema(){
	CURRENT_VALUE=$(get_config_schema)
	EXPECTED_VALUE="objectclasses: ( 1.3.6.1.4.1.42.2.27.9.2.25 NAME 'sunservice' DESC 'object containing service information' SUP top STRUCTURAL MUST ou MAY ( labeledURI $ sunServiceSchema $ sunKeyValue $ sunxmlKeyValue $ sunPluginSchema $ description ) X-ORIGIN 'Sun Java System Identity Management' X-SCHEMA-FILE '99-user.ldif' )
objectclasses: ( 1.3.6.1.4.1.42.2.27.9.2.104 NAME 'sunRealmService' DESC 'object containing service information for realms' SUP top STRUCTURAL MAY ( o $ labeledURI $ sunKeyValue $ sunxmlKeyValue $ description ) X-ORIGIN 'Sun Java System Identity Management' X-SCHEMA-FILE '99-user.ldif' )
objectclasses: ( 1.3.6.1.4.1.42.2.27.9.2.27 NAME 'sunservicecomponent' DESC 'Sub-components of the service' SUP organizationalUnit STRUCTURAL MUST ou MAY ( labeledURI $ sunserviceID $ sunsmspriority $ sunKeyValue $ sunxmlKeyValue $ description ) X-ORIGIN 'Sun Java System Identity Management' X-SCHEMA-FILE '99-user.ldif' )"
	 
	if [[ "$CURRENT_VALUE" == "$EXPECTED_VALUE" ]]
	then
		printf "Config schema has been applied ${GREEN}Successfully! ${NC}as expected\n"
	else
		printf "Config schema has been ${RED}FAILED! ${NC} NOT expected\n"
		printf "Current value is/are:\n$CURRENT_VALUE\n\n"
		printf "Expected value is/are:\n$EXPECTED_VALUE\n" 
		exit 1
	fi
}


test_modify_schema(){
	CURRENT_VALUE=$(get_modify_schema)
	EXPECTED_VALUE='ds-cfg-global-aci: (target = "ldap:///cn=schema")(targetattr = "attributeTypes || objectClasses")(version 3.0; acl "Modify schema"; allow (write) (userdn = "ldap:///uid=openam,ou=ServiceAccounts,dc=ulti,dc=io");)'
	 
	if [[ "$CURRENT_VALUE" == "$EXPECTED_VALUE" ]]
	then
		printf "Modify schema has been allowed ${GREEN}Successfully! ${NC}as expected\n"
	else
		printf "Modify schema has been ${RED}FAILED! ${NC} NOT expected\n"
		printf "Current value is/are:\n$CURRENT_VALUE\n\n"
		printf "Expected value is/are:\n$EXPECTED_VALUE\n" 
		exit 1
	fi
}

test_https_connection(){
	CURRENT_VALUE=$(get_https_connection)
	EXPECTED_VALUE="test_https_connection"
	 
	if [[ "$CURRENT_VALUE" == "$EXPECTED_VALUE" ]]
	then
		printf "HTTP connection has been restricted ${GREEN}Successfully! ${NC}as expected\n"
	else
		printf "HTTP connection has been ${RED}FAILED! ${NC} NOT expected\n"
		printf "Current value is/are:\n$CURRENT_VALUE\n\n"
		printf "Expected value is/are:\n$EXPECTED_VALUE\n" 
		exit 1
	fi
}

test_anonymous_access(){
	CURRENT_VALUE=$(get_anonymous_access)
	EXPECTED_VALUE='ds-cfg-global-aci: (extop="1.3.6.1.4.1.26027.1.6.1 || 1.3.6.1.4.1.26027.1.6.3 || 1.3.6.1.4.1.4203.1.11.1 || 1.3.6.1.4.1.1466.20037 || 1.3.6.1.4.1.4203.1.11.3") (version 3.0; acl "Anonymous extended operation access"; allow(read) userdn="ldap:///anyone";)
ds-cfg-global-aci: (targetcontrol="2.16.840.1.113730.3.4.2 || 2.16.840.1.113730.3.4.17 || 2.16.840.1.113730.3.4.19 || 1.3.6.1.4.1.4203.1.10.2 || 1.3.6.1.4.1.42.2.27.8.5.1 || 2.16.840.1.113730.3.4.16 || 1.2.840.113556.1.4.1413 || 1.3.6.1.4.1.36733.2.1.5.1") (version 3.0; acl "Anonymous control access"; allow(read) userdn="ldap:///anyone";)
ds-cfg-global-aci: (target="ldap:///cn=schema")(targetscope="base")(targetattr="objectClass||attributeTypes||dITContentRules||dITStructureRules||ldapSyntaxes||matchingRules||matchingRuleUse||nameForms||objectClasses")(version 3.0; acl "User-Visible Schema Operational Attributes"; allow (read,search,compare) userdn="ldap:///anyone";)
ds-cfg-global-aci: (target="ldap:///")(targetscope="base")(targetattr="objectClass||namingContexts||supportedAuthPasswordSchemes||supportedControl||supportedExtension||supportedFeatures||supportedLDAPVersion||supportedSASLMechanisms||supportedTLSCiphers||supportedTLSProtocols||vendorName||vendorVersion")(version 3.0; acl "User-Visible Root DSE Operational Attributes"; allow (read,search,compare) userdn="ldap:///anyone";)'
	 
	if [[ "$CURRENT_VALUE" == "$EXPECTED_VALUE" ]]
	then
		printf "Anonymous access has been revoked ${GREEN}Successfully! ${NC}as expected\n"
	else
		printf "Anonymous access has been ${RED}FAILED! ${NC} NOT expected\n"
		printf "Current value is/are:\n$CURRENT_VALUE\n\n"
		printf "Expected value is/are:\n$EXPECTED_VALUE\n" 
		exit 1
	fi
}

test_cache_size(){
	CURRENT_VALUE=$(get_cache_size)
	EXPECTED_VALUE="dn: ds-cfg-backend-id=userRoot,cn=Backends,cn=config
ds-cfg-db-cache-percent: 70"
	 
	if [[ "$CURRENT_VALUE" == "$EXPECTED_VALUE" ]]
	then
		printf "Cache size has been set ${GREEN}Successfully! ${NC}as expected\n"
	else
		printf "Catch size has been ${RED}FAILED! ${NC} NOT expected\n"
		printf "Current value is/are:\n$CURRENT_VALUE\n\n"
		printf "Expected value is/are:\n$EXPECTED_VALUE\n" 
		exit 1
	fi
}

test_virtual_attributes(){
	EXPECTED_VALUE="enabled        : false"
	VIRTUAL_ATTRIBUTES=("Collective Attribute Subentries" "entryDN" "entryUUID" "governingStructureRule" "hasSubordinates" "isMemberOf" "numSubordinates" "Password Expiration Time" "Password Policy Subentry" "structuralObjectClass" "subschemaSubentry")

	for NAME in $(seq 0 $((${#VIRTUAL_ATTRIBUTES[*]} - 1)))
	do
		CURRENT_VALUE=$(get_virtual_attribute "${VIRTUAL_ATTRIBUTES[$NAME]}" )
		if [[ "$CURRENT_VALUE" == "$EXPECTED_VALUE" ]]
		then
			printf "${VIRTUAL_ATTRIBUTES[$NAME]} has been disabled ${GREEN}Successfully! ${NC}as expected\n"
		else
			printf "${VIRTUAL_ATTRIBUTES[$NAME]} has been ${RED}FAILED! ${NC} NOT expected\n"
			printf "Current value is/are:\n$CURRENT_VALUE\n\n"
			printf "Expected value is/are:\n$EXPECTED_VALUE\n" 
			exit 1
		fi
	done
}

test_ds_config_store(){
	set_common_variables
  	set_ds_config_store_variables
  	test_root_suffix
	test_config_data
	test_openam_access
	test_serviceaccounts_suffix
	test_openam_privileges
	test_config_schema
	test_modify_schema
	#test_https_connection
	## This test will fail because http connection handler is not evet configured. That function works only if it is configured and set it to disable.
	test_anonymous_access # NEED TO BE VERIFIED!!!
	test_cache_size
}

test_ds_cts_store(){
	set_common_variables
  	set_ds_cts_store_variables
 	test_root_suffix
	test_config_data
	test_openam_access
	test_serviceaccounts_suffix
	test_openam_privileges
	test_cts_schema
	test_modify_schema
	#test_https_connection
	## This test will fail because http connection handler is not evet configured. That function works only if it is configured and set it to disable.
	test_anonymous_access # NEED TO BE VERIFIED!!!
	test_cache_size
	test_virtual_attributes
}