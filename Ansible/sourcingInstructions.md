How to correctly set up sourcing of the rc file etc:

1. Download the openrc v3 file and save it somewhere (I have it in the local repo and .gitignore)
2. Download the clouds.yaml file (From the API access section) and put it in ~/.config/openstack/clouds.yaml (default place to look for it for tools)
3. Complete the VPN access correctly (Change your passwords on student login and open stack if you havent, cause you will have to enter them)
4. Run the following command in the directory of the openrc v3 file:
    source <insertFileNameHere>
5. edit clouds.yaml and add the following lines under the auth section:
    password: <insertYourPasswordWithin"">  (Preferably under the login name)
    project_domain_name: "Default"  (Preferably under the user domain).

    It should look something like this:

clouds:
  openstack:
    auth:
      auth_url: https://cscloud.lnu.se:5000/v3
      username: "username-2dv517"
      password: "MySecretPasswordWhoopWhoop"
      project_id: 3505b00815024d79a8da6d33133f302f
      project_name: "username-2dv517-ht21"
      user_domain_name: "Default"
      project_domain_name: "Default"
    region_name: "RegionOne"
    interface: "public"
    identity_api_version: 3
