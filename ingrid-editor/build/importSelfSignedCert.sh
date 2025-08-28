#!/bin/sh
CERT_NAME=$2
if [ -z "$CERT_NAME" ];
then
CERT_NAME=$1
fi

CERT_FILE_NAME=$1
printf "Trying to import certificate to jvm keystore\n"
if [ ! -z "$CERT_FILE_NAME" ];
then
    if [ ! -z "$JAVA_HOME" ];
    then
    printf "environment variable JAVA_HOME exists\n"
    if [ -f "/certificates/$CERT_FILE_NAME" ];
    then
        printf "certificate $CERT_FILE_NAME is present\n"
        if [ -x "$JAVA_HOME/bin/keytool" ];
        then
            printf "importing $CERT_FILE_NAME with $JAVA_HOME/bin/keytool into keystore $JAVA_HOME/security/cacerts\n"
            printf "given alternative name: $CERT_NAME\n"
            "$JAVA_HOME/bin/keytool" -import -alias "$CERT_NAME" -keystore $JAVA_HOME/lib/security/cacerts -file "/certificates/$CERT_FILE_NAME" -storepass changeit -noprompt
            if [ $? -eq 0 ];
            then
            printf "Successfully imported $CERT_FILE_NAME with $JAVA_HOME/bin/keytool into keystore $JAVA_HOME/security/cacerts\n"

            else
            printf "\n\n"
            printf "there was an ERROR importing the certificate!\n"
            printf "\n\n"
            exit 1

            fi
        else
            printf "keytool couldn't be found\n"
            exit 1
        fi
    else
        printf "couldn't find $CERT_FILE_NAME in directory /certificates\n"
        exit 1
    fi
    else
    printf "Environmnet variable JAVA_HOME is missing or empty\n"
    exit 1
    fi
else
printf "No certificate file name given\n"
exit 1
fi
exit 0
