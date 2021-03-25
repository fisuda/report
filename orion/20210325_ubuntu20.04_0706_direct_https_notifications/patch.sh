#!/bin/sh
sed -e "s/Peer certificate cannot be authenticated[^\"]*/SSL peer certificate or SSH remote key was not OK/" /opt/fiware-orion/test/functionalTest/cases/0706_direct_https_notifications/direct_https_notifications_no_accept_selfsigned.test
