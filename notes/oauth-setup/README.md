# Preparing for Users

## Introduction

A newly installed OpenShift cluster has only an in-built user called `kubeadmin`, which has cluster administrator permissions. For day-to-day operations on the cluster, more users need to be added.

## OAuth

The OpenShift control plane includes a built-in OAuth Server, which integrates with back-ends called *identity providers* to authenticate users. The OAuth server can provide a browser-based user interface for entering user name and password, or can forward to a user interface provided by the identity provider. At the end of a successful authentication, the OAuth server generates a *token*, which can be used to log into OpenShift.

When you access the OpenShift Web Console at `https://console-openshift-console.apps.CLUSTER.DOMAIN`, this flow - from the web console to the OAuth Server to the identity provider interface back to OAuth Server and back to the web console - is handled automatically.

For logging in via CLI, you can visit `https://oauth-openshift.apps.CLUSTER.DOMAIN/oauth/token/request`. This will log you in through the browser interface, and show you the commands you need to run to use the token generated by the OAuth server in your CLI.

## Setting up Identity Providers

Identity providers can be set up using the web console, by navigating to the `Administration`/`Cluster Settings` page. In the `Configuration` tab on that page, there will be two entries named OAuth. The **first** one is to be modified. The context menu for that entry provides options for configuring provides such as HTPassword and GitHub.

## Setting up GitHub Identity Provider

The instructions below assume OpenShift Local. Replace `*.apps-crc.testing` in the URLs shown below with `*.apps.YOURCLUSTER.YOURDOMAIN` to use them on your OpenShift cluster.

1. Decide on a single-word, all lowercase name for the auth provider. Eg. `githubusers`. We will refer to it as AUTHPROVIDERNAME in subsequent steps.
1. On GitHub:
    * Go to Current User/Settings/Developer Settings/OAuth apps ([https://github.com/settings/developers](https://github.com/settings/developers))
    * Create a new OAuth app, with:
      - Homepage Url: https://oauth-openshift.apps-crc.testing/
      - Authorization callback URL: https://oauth-openshift.apps-crc.testing/oauth2callback/AUTHPROVIDERNAME
    * Make a note of the Client Id (CLIENTID) and Client secret (CLIENTSECRET).
1. On the OpenShift Local console:
    * Go to Administration/Cluster Settings/Configuration ([https://console-openshift-console.apps-crc.testing/settings/cluster/globalconfig](https://console-openshift-console.apps-crc.testing/settings/cluster/globalconfig))
    * Find and click "OAuth" ([https://console-openshift-console.apps-crc.testing/k8s/cluster/config.openshift.io~v1~OAuth/cluster](https://console-openshift-console.apps-crc.testing/k8s/cluster/config.openshift.io~v1~OAuth/cluster))
    * Click "Add". Choose "GitHub"
    * Provide:
      * Name: AUTHPROVIDERNAME
      * Client Id: CLIENTID
      * Client Secret: CLIENTSECRET
      * Organization: Any GitHub organization whose users will be allowed into Openshift
    * The other options can be left blank. Click "Add".
1. *Wait for 5 minutes or so*. This is important. Pod in the namespace `openshift-authentication` has to be recreated automatically before the next step.
1. Log out from the web console, and log back in. It should give you the option of logging in using the AUTHPROVIDERNAME provider. Use that, and your GitHub login.
1. To log in from the terminal for tools like `oc` or `kubectl`, browse to: [https://oauth-openshift.apps-crc.testing/oauth/token/request](https://oauth-openshift.apps-crc.testing/oauth/token/request). Choose to use the AUTHPROVIDERNAME provider to log in using your GitHub credentials. It will give you an oc command to run. Run that in a terminal, and you will be logged in as your GitHub user.

## Permissions

* Newly created users using any authentication provider have permissions only to log in, and create new projects.
* Any user who creates a new project will have full permissions on that project.
* User-relevant permissions are contained in three `ClusterRoles` called `admin`, `edit` and `view`. When any user creates a project, a `Namespace` with the same name is created. Within it, a `RoleBinding` named `admin` is created, which assigns the `ClusterRole` called `admin` to the user that created the project.
* More users can be added to the project using:
    `oc adm policy add-role-to-user ROLE USERNAME`, where:
      * ROLE is one of `admin`,`edit` or `view`
      * USERNAME is the username
    This will create a new `RoleBinding` in the project namespace, granting the appropriate `ClusterRole` to the user
* Users can check their permissions using `oc auth can-i OPERATIONS`, or check other users' permissions using `oc auth can-i OPERATIONS --as=OTHERUSER`. They can also use `oc adm policy who-can OPERATIONS`.
* The clusterrole `self-provisioners` contains permissions for creating new projects, via creation of `ProjectRequest` objects. The clusterrolebinding `self-provisioners` gives permissions of that clusterrole, by default to `system:authenticated:oauth`. This is why new users can create projects by default. 

### Interesting links

* [https://cookbook.openshift.org/projects-and-user-collaboration/how-do-i-allow-another-user-to-work-on-my-project.html](https://cookbook.openshift.org/projects-and-user-collaboration/how-do-i-allow-another-user-to-work-on-my-project.html)
* [https://access.redhat.com/documentation/en-us/openshift_container_platform/4.13/html-single/building_applications/index#about-project-creation_configuring-project-creation](https://access.redhat.com/documentation/en-us/openshift_container_platform/4.13/html-single/building_applications/index#about-project-creation_configuring-project-creation)