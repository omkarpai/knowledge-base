---
author: ["Omkar Pai"]
title: "Using multiple GitHub accounts without login"
date: "2025-03-07"
description: "Learn a clean way to set-up multiple Git identities with SSH on a single system"
summary: "Learn a clean way to set-up multiple Git identities with SSH on a single system"
tags: ["git", "GitHub", "ssh"]
categories: ["git"]
showToc: true
TocOpen: true
draft: false
hideSummary: false
---

### Introduction

Since you are reading about this problem, you might already be using SSH to authenticate with GitHub.
If not, then I would highly recommend setting it up using any methods described in this guide<br><br>
Most guides covering this topic tend to include some fiddling around to get multiple identities working.
This includes the following:

- Setting user configuration at the repository level
- Setting up multiple hosts in the SSH configuration
- Changing hosts in the SSH clone URL / modifying git origin

These methods work, but personally the additional tweaks make it a tad bit annoying. I find the best way to deal
with this is to have dedicated working directories for each Git identity / GitHub account which are set up once.<br><br>
This is made possible with the `[include]` & `[includeIf]` directives in a `.gitconfig`

This guide is `Linux` focused, but a similar concept should also be applicable on `Windows` & `macOS`

### Generating new SSH key pairs

{{< note >}}
Windows users might need to find an alternative to `ssh-keygen` for generating key pairs
{{< /note >}}

```
ssh-keygen -t ed25519 -C "YOUR_EMAIL@YOUR_PROVIDER.com"
```

- `-t` switch is to set the signing algorithm. <br>Available options: `[-t dsa | ecdsa | ecdsa-sk | ed25519 | ed25519-sk | rsa]`
- `-C` switch sets a comment on the generated key.

`ssh-keygen` will then ask you to enter a file to save the key. You can leave this empty to use the default path `/home/YOUR_USER/.ssh/id_ed25519` or
specify a filename of your choice.
<br>

`ssh-keygen` will further ask for a passphrase. You can also leave this empty and proceed.
<br>

At the end of this section you should now be having a pair of files `id_ed25519` and `id_ed25519.pub`. (Assuming the default file names).

{{< tip >}}
A good idea is to move the SSH key pairs to `.ssh` in your home directory and naming them appropriately to avoid confusion.<br>
Example location: `/home/YOUR_USER/.ssh/key_pairs`<br>
Example naming: `gh_personal_ed25519`,`gh_personal_ed25519.pub`
{{< /tip >}}

### Adding the public key to GitHub

We now need to add the public key `id_ed25519.pub` to GitHub.

- On your GitHub profile page, navigate to GitHub settings.
- Navigate to `SSH and GPG keys` > `New SSH key`

Fill out the form fields on the following page:

- Title - same as the name for the key pair(`id_ed25519` or `gh_personal_ed25519`). This only serves for identification purposes.
- Key type - Authentication key.
- Key - Paste the entire contents of the .pub file here.

Click `Add SSH key`.

### Adding the private key to SSH config

The two methods described below are mutually exclusive. You can choose to follow either one of them based on what you want to achieve.

{{< note >}}
`.gitconfig`,folder and SSH config paths for Windows users might be different
{{< /note >}}

#### Method 1: Adding a single system-wide identity.

I am including this method for completeness’ sake as similar functionality can be achieved with [Method 2](#method-2-adding-folder-specific-identities).

- Edit your SSH config `/home/YOUR_USER/.ssh/config` and add the following.

```
Host github.com
    HostName github.com
    IdentityFile ~/.ssh/PATH_TO_YOUR_PRIVATE_KEY
    User git
```

You can now use the SSH URLs to clone GitHub repositories and use other Git functionality.

#### Method 2: Adding folder specific identities

This method assumes you want to use two different GitHub accounts (personal & work) on the same system.<br>

- Create a folder `/home/YOUR_USER/work` in which you want the work identity to be used. We will use the personal identity for any other folder.

You will need to then generate two different key pairs and add them to your work & personal GitHub accounts as described in the [previous section](#adding-the-public-key-to-github).<br>

We use different `.gitconfigs` to specify the different private key files to use for specific directories.

- Set up the following files in your home directory

`/home/YOUR_USER/.gitconfig`

```
[include]
  path = ./.gitconfig-personal

[includeIf "gitdir:/home/YOUR_USER/work/"]
  path= ./.gitconfig-work
```

`/home/YOUR_USER/.gitconfig-personal`

```
[user]
	email = YOUR_PERSONAL_ACC_EMAIL
	name = YOUR_PERSONAL_ACC_NAME
[core]
    sshCommand = "ssh -i PATH_TO_YOUR_PERSONAL_PRIVATE_KEY"
```

`/home/YOUR_USER/.gitconfig-work`

```
[user]
	email = YOUR_WORK_ACC_EMAIL
	name = YOUR_WORK_ACC_NAME
[core]
    sshCommand = "ssh -i PATH_TO_YOUR_WORK_PRIVATE_KEY"
```

This will now automatically use your work identity when the current directory contains `/home/YOUR_USER/work/` & your personal identity for all other directories.
You could also extend this for more folders and identities as required.

You can now use the SSH URLs of any private work repositories to clone them in the `/home/YOUR_USER/work/` directory.
