#!groovy

import jenkins.model.*
import hudson.security.*
import jenkins.security.s2m.AdminWhitelistRule

def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("admin", "admin123")
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)
instance.save()


def instance2 = Jenkins.getInstance()

def hudsonRealm2 = new HudsonPrivateSecurityRealm(false)
hudsonRealm2.createAccount("user1","password123")
instance2.setSecurityRealm(hudsonRealm2)

def instance3 = Jenkins.getInstance()

def hudsonRealm3 = new HudsonPrivateSecurityRealm(false)
hudsonRealm3.createAccount("user2","password321")
instance3.setSecurityRealm(hudsonRealm2)

Jenkins.instance.getInjector().getInstance(AdminWhitelistRule.class).setMasterKillSwitch(false)
