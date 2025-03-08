---
author: ["Omkar Pai"]
title: "Using multiple GitHub accounts without login"
date: "2025-03-07"
description: "Learn a clean way to set-up multiple Git identites with SSH on a single system"
summary: "Learn a clean way to set-up multiple Git identites with SSH on a single system"
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
with this is to have dedicated working directories for each Git identity / GitHub account.<br><br>
This is made possible with the `[include]` & `[includeIf]` directives in a `.gitconfig`

### Generating the key pairs
