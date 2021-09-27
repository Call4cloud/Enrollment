# Default Intune Enrollment




**Preface**

This document will guide you and show you which steps to take to deploy your whole Intune tenant within a few minutes.  Before we can configure the tenant with Powershell, we need to make sure we have configured some prereqs.

Google Connection/Apple Connection/Microsoft Store Connection/Approving the Google apps/adding the Microsoft Store Apps and the company branding

When you make sure, you have configured these and followed this document, you can start enrolling your tenant with a basic configuration.. Of course, every customer is different so there are always adjustments to be made

I am using VScode to deploy/configure our tenants. When using VScode you could clone this repository and start using it for your own. Please check out the 
$ScriptPath = $PSScriptRoot variable, if needed change it to your own folder 






**Contents**

Step 1a. Configure Apple MDM (Manually)

Step 1b. Configure Android MDM (Manually)

Step 1c: Add Android Apps (Manually)

Step 1d: Configure Company Branding (Manually)

Step 1e: Configure Microsoft Business Store  (Manually)

Step 2: Configure Tenant 

Step 3: Create/Upload/Assign Intune Apps

Step 4: Import Device Configuration Profiles

Step 5: Import Compliance Policies

Step 6: Configure Windows Update

Step 7: Configure Windows Hello

Step 8: Deploy Conditional Access

Step 9: Security Level 1/4 





(Manually) = Some steps are need to be performed manually before we can continue enrolling the whole Intune Tenant 








# Step 1A Configure Apple MDM: 
1. Device Enrollment and then Apple Enrollment and select  “Apple MDM Push Certificate”
2. Click on “Agree to the terms” and  download the “CSR” File
3. The Intune CSR is now being downloaded
4. Click on  “Create your MDM push certificate.” A valid apple id  is required,  create one if necessary : <http://appleid.apple.com>. 
5. Log in , with your created apple id
6. Click on  “Create a Certificate” after you logged in
7. Upload the Intune CSR file you downloaded earlier
8. Now you can download the intune certificaat
9. Open Intune back again and enter the apple id corresponding to the certificate and upload the certficate you downloaded in step 9


# Step 1B Configure Android MDM 
1. First we need (just like with Aple ) a Google account 
2. Open Intune and select device enrollment  - Android enrollment
3. Click on “Managed google play
4. Make sure you “agree” and click on start google to create a connetion
5. Please make sure you are signed in with the proper account
6. If you are not signed in or not yet created a google account, click on add account and create a new company google account 
7. Configure the company name when asked for
8. Scroll down and make sure you are agreeing to the terms and press confirm afterwards
9. Make sure you document the apple and google accounts used!




# Step 1C Adding Android Apps
Now we configured the Google account let’s add some apps

1. Open Apps and Android Apps and click on add
2. Choose  App type: Beheerde/Managed  Google Play and click on “open”
3. Search for each App and approve it
4. You will need to do this for each app you want to use, so make sure you have added all the apps
5. No we have added all the apps, we still need to make sure we “sync” them back to Intune… so don’t forget to sync them !!



# Step 1D Configure Company branding

Please make sure you don’t forget to configure the Company branding by creating a new banner logo door een banner logo etc. You could do so by logging in into portal.azure.com. Choosing Azure active directory and company branding

Also make sure you configure the company name by surfing to this portal

<https://devicemanagement.microsoft.com/#blade/Microsoft_Intune_DeviceSettings/TenantAdminMenu/companyPortalBranding>




# Step 1E Microsoft Business Store Linken aan intune (company portal)

1. Log in into Microsoft Endpoint Manager Portaal and  open the Tenant administration blade and click on “Enable” and on “open the business store”
2. Sign in with the admin Credentials
3. Click on  “Manage/Beheren”. 
4. When asked, make sure you accept it
5. Lets create the intune connection by clicking on settings/distribuate and clicking on activate at the bottom of the screen
6. Now we have connected the store to Intun, let’s add some apps.  Please make sure you have add the company portal app
7. Click on “get the app” and agree to the terms
8. Make sure you are doing the same for the email and calander App
9. When you have added all the apps, please make sure (just like with google) press the sync botton
10. Please make sure you configured the company portal app as required 
11. Configure the Email and calander apps to make sure the assignment is uninstall!


# Step 1F Solarwinds package   (when Using Solarwinds)

1. Download the site installation package 
2. Choose the proper tenant and click on download remote worker installer
3. Extract the zip file to this folder c:\intune\packages\solarwinds
4. Download the intunewinapp utility and start creating the intune package
https://go.microsoft.com/fwlink/?linkid=2065730
5. **Source folder:** c:\intune\packages\solarwinds 
   **Setup file:** agent.exe
   **Destination folder:** c:\intune\packages\solarwinds 

Now let's fire up the Default_Enrollment.ps1. I will shortly describe what it does 

# Step 2 Configure Tenant 

.\DU\DU2a to DU2i

Please note that we are creating the "MS365BusinessLicences" group. This group is used to configure Group Licensing/MDM Scope/Configure who may Join Azure Ad

# Step 3a Create Intune Apps: 

When using the solarwinds app , make sure you have it in the right location

# Step 3b Upload and assign Intune Apps 

\# Windows10 Apps

.\DU\DU3b\_Windows10\_Upload\_Basic\_Apps.ps1

\# iOS Apps

.\DU\DU3b\_iOS\_Upload\_Basic\_Apps.ps1

\# Office365 Apps

.\DU\DU3b\_Office365\_Upload\_Apps.ps1

\# Edge App

.\DU\DU3b\_Edge\_Upload\_App.ps1

\# Chocolatey Apps

.\DU\DU3b\_Chocolatey\_Upload\_Basic\_Apps.ps1



\#### Apps Assignment  ###### 

\# Windows10 Apps

.\DU\DU3b\_Windows10\_Assign\_Basic\_Apps.ps1

\# iOS Apps

.\DU\DU3b\_iOS\_Assign\_Basic\_Apps.ps1

\# Chocolatey Apps

.\DU\DU3b\_Chocolatey\_Assign\_Basic\_Apps.ps1 

\# Chocolatey Apps Logos uploaden

.\DU\DU3b\_Chocolatey\_Assign\_Large\_Icons.ps1






# Step 3c Configure Enrollment status page* 

\#### Enrollment Status page configureren #####

.\DU\DU3c\_Config\_Enrollment\_Status\_Page.ps1


-Check out if which apps you want to mark as required in the User Enrollment status page

<https://devicemanagement.microsoft.com/#blade/Microsoft_Intune_DeviceSettings/DevicesEnrollmentMenu/windowsEnrollment>


# Step 4 Configure Intune Device Configuration Policies

***Step 4a***

\# Importing Administrative Configurations 

.\DU\DU4a\_DeviceConfigurationADMX\_Import\_FromJSON.ps1

.\DU\Du4a\_DeviceConfigurationADMX\_Assignment.ps1



***Step 4b***

\# Importing Device Configurations 

.\DU\Du4b\_Windows10\_ImportAllDeviceConfigs.ps1

.\DU\DU4b\_AppConfigurationPolicy\_ImportFromJSON.ps1

.\DU\DU4b\_AppConfigurationPolicy\_Assignment.ps1



***Step 4c***

\# Importing Powershellscripts

.\DU\DU4c\_Enroll\_Windows10\_Powershellscripts.ps1 

***Step 4d***

\# Upoad FireWall Rules

.\DU\DU4d\_Windows10\_firewallRules.ps1 


# Step 5 Creating Compliance Policies

.\DU\DU5\_Import\_Compliance\_Policies.ps1 

# Step 6 Configure WU4B

.\DU\DU6\_Config\_WindowsUpdate.ps1


# Step 7 Configure Windows Hello 

.\DU\DU7\_Config\_WindowsHello.ps1 

# Step 8 Import Conditional Access Rules 

.\DU\DU8\_Config\_WindowsHello.ps1 

# Step 9 Import Security Level 1(SL1) 

.\SL\SL1TOTAALps1 








