#!/bin/sh
pushd ~/dotfiles
home-manager switch -f ./users/mbpnix/home.nix
popd
