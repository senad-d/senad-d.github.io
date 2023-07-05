---
title: Git workflow with rebase
date: 2021-02-07 12:00:00
categories: [Software, Git]
tags: [git, basics]
---
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/git-banner.png?raw=true)


## The basics

Out of the gate, the goal of both merging and rebasing is to take commits from a feature branch and put them onto another branch. Let’s start with how a quote-on-quote “normal” merge makes that happen.

### Merging

Say I have a graph that looks like this. As you can see, I split off my feature branch at commit 2, and have done a bit of work.

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/git-merge-graphic.png?raw=true)

If I run a ***merge***, git will stuff all of my changes from my feature branch into one large ***merge*** commit that contains ***ALL*** of my feature branch changes. It will then place this special merge commit onto master. When this happens, the tree will show your feature branch, as well as the master branch. Going further, if you imagine working on a team with other developers, your git tree can become complex: displaying everybody else’s branches and merges.

### Rebasing

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/git-rebase-graphic.png?raw=true)

Now let’s take a look at how rebase would handle this same situation. Instead of doing a ***git merge***, I’ll do a ***git rebase***. What rebase will do is take all of the commits on your feature branch and move them on top of the master commits. Behind the scenes, git is actually blowing away the feature branch commits and duplicating them as new commits on top of the master branch (remember, under the hood, commit objects are immutable and immovable). What you get with this approach is a nice clean tree with all your commits laid out nicely in a row, like a timeline. Easy to trace.

### Rebasing caveats

At this point, I think I better mention some caveats. Rebase doesn’t play super well with open-source projects and pull requests since it can be hard to trace, especially small changes that are introduced to a codebase. This point is a bit nuanced, but here is [an article](https://www.atlassian.com/git/tutorials/merging-vs-rebasing#the-golden-rule-of-rebasing) that does a good job of explaining why.

It can also be dangerous if you’re working on a shared branch with other developers because of how Git rewrites commits when rebasing; however, in the workflow example below, I’ll show you how to mitigate this risk.

## In practice: the actual commands

```shell
# With my local master branch checked out
git pull
```

Next, check out a new branch so I can write and commit code to this branch – keeping my work separated from the master branch

```shell
git checkout -b my_cool_feature
```

As I’m developing my feature, I’ll make a few commits…

```shell
git add .
git commit -m 'This is a new commit, yay!'
```

> Note: while I’m developing it’s likely that my fellow developers will have shipped some of their own changes to remote master. That’s ok, we can deal with that later. 
{: .prompt-tip }

Now that I’m done developing my feature, I want to merge my changes back into remote master. To begin this process I’ll switch back to local master branch and pull the latest changes. This ensures my local machine has any new commits submitted by my teammates.

```shell
git checkout master
git pull
```

What I want to do now is make sure my feature will jive with any new changes from remote master. To do this, I’ll checkout my feature branch and rebase against my local master. This will re-anchor my branch against the latest changes I just pulled from remote master. Additionally at this point, Git will let me know if I have any conflicts and I can take care of them on my branch

```shell
git checkout my_cool_feature
git rebase master
```

Now that my feature branch doesn’t have any conflicts, I can switch back to my master branch and place my changes onto master.

```shell
git checkout master
git rebase my_cool_feature
```

Since I synced with remote master before doing the rebase, I should be able to push my changes up to remote master without issues.

```shell
git push
```

## More reading

I certainly didn’t try to dive very deeply into the inner working of rebase (or merge) in this short article so if you’re curious and want to go further, check out these articles:

-   [Merging vs Rebasing](https://www.atlassian.com/git/tutorials/merging-vs-rebasing)
-   [Official Git rebase documentation](https://git-scm.com/book/en/v2/Git-Branching-Rebasing)