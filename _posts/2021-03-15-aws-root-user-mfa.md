---
title: Enable MFA for Root User
date: 2022-04-04 13:00:00
categories: [Cloud, AWS]
tags: [aws, account]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

# Enable MFA for the Root User, follow the steps below:

1.  Sign in to the AWS management console using the account root user credentials
    
2.  Navigate to the **IAM** service
    
    ![AWS Services list](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/aws-services-list.png?raw=true){: .shadow }
    
3.  On the IAM Dashboard, check if MFA is enabled or not. In the picture below we can see that MFA has not been enabled for the root user
    
    ![IAM Dashboard](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/iam-dashboard.png?raw=true){: .shadow }
    
4.  To enable MFA, click on **Add MFA**
    
    ![AWS add MFA](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/aws-add-mfa.png?raw=true){: .shadow }
    
5.  This will open a new tab. In the new tab, click on **Activate MFA**
    
    ![AWS activate MFA](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/aws-activate-mfa.png?raw=true){: .shadow }
    
6.  This will show a pop up with three options. You can select any one. In this article we will select the **Virtual MFA device** option and click on **Continue**
    
    ![AWS manage MFA device](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/aws-manage-mfa-device.png?raw=true){: .shadow }
    
7.  If you have the option of scanning QR code, click on Show QR code and scan it to proceed with the set up. You can also set it up using the secret key. Click on show secret key, copy the key, and set up the MFA device.
    
    ![AWS set MFA device](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/aws-set-mfa-device.png?raw=true){: .shadow }
    
8.  Now provide two consecutive MFA codes and click on **Assign MFA.** This will set up the virtual MFA device
    
    ![AWS Assign MFA](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/aws-assign-mfa.png?raw=true){: .shadow }
    
9.  To verify the success of the setting change, go back to the IAM dashboard and refresh the tab to confirm if the MFA has been successfully setup
    
    ![IAM dashboard MFA assigned](![https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/iam-dashboard-mfa-assigned.png?raw=true)){: .shadow }
