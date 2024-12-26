---
title: Send your Mendix App to GitHub
date: 2021-02-06 13:00:00
categories: [Software, Git]
tags: [git, remote]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/git-banner.png?raw=true)

Are you developing a new application with Mendix using a free license and finding that one environment is not sufficient? Would you like to send your code to GitHub so that you can run your application, for example, on AWS, or do you simply want to store your project in a private GitHub repository? You can follow the following steps to achieve exactly that with minimal effort.

### Requirements:

-   Mendix Studio Pro 9.24.4 or higher
-   Git installed on your computer and connected to GitHub
-   GitHub repository for your project (public/private)
-   Project utilizing Mendix's Git server for version control

### Procedure:

1.  Open the folder on your device where your project is located.
2.  Enable the display of hidden files within the folder and open the `.git/conf` file using a text editor.
3.  Take note of your current remote origin URL so that you can revert to it later. 
- Example: `https://git.api.mendix.com/<number>.git`
4.  Take note of the URL of the repository you intend to switch to. 
- Example: `https://github.com/<user-name>/<name>.git`
5.  Within the project folder, open a Git terminal and enter the following commands:
    
    ```shell
    git remote set-url origin https://github.com/<user-name>/<name>.git
    
    git push
    ```
    
6.  Once the transfer is complete, return to Mendix's Git in order to continue working normally:
    
    ```shell
    git remote set-url origin https://git.api.mendix.com/<number>.git
    ```

6.  Now if you are using different branch in your Mendix git project you'll need to go to the GitHub repository and Merge the new branch to main branch.

### Conclusion: 

From now on, whenever you want to send changes from your project to another Git repository, simply follow the aforementioned steps, and you will have no issues with versioning your project.