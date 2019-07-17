---
title: contribution
id: contribution
---
Thanks for taking the time to contribute!

# Commits

## Messages

A development (feature, fix, etc.) must be contained in one commit.

The commit message must be based on the <https://www.conventionalcommits.org> specification and written in english. The identifier of the issue must be placed in the short description.

    <type>[optional scope]: #<issue>, <description>

    [optional body]

    [optional footer]

## Changelog

The changelog is generated from the commit messages then manually edited. The commit messages must be very clean and descriptive (what feature has been implemented or what bug has been fixed and how).

## Pull Requests and reviews

A development can be integrated with a Pull Request, through a review process, if one of the following conditions is matched:

-   it is an external contribution

-   it is part of an Open Digital Education "chantier" project (ramping-up fresh developers, etc.)

-   it is risky (ex. the contributor is not comfortable with the technical or functional domain)

If the Pull Request is opened by an Open Digital Education contributor, the PR is prefixed with "\[ODE\]".

The Pull Request is integrated with the "Squash and Merge" option to match the mono-commit criteria.

# Branches

-   **master**: the main branch. It stores all the public commit log and tag (mapped to release). It must never be "pushed force".

-   **dev**: the branch holding the fixes of the latest release.

-   **next**: the branch holding the features of the next release.

-   **my-topic-branch**: a topic branch for a particular project. It must be rebased as often as possible.

## 1. Derive *my-topic-branch* from *next*

Each new feature must be isolated on a dedicated branch.

                                                 K---L---M  (my-topic-branch)
                                                /
                                           H---I  (next)
                                          /
                                 E---F---G  (dev)
                                /
                   A---B---C---D  (master)

## 2. Isolation test: Rebase often *my-topic-branch* on *next* and test your feature.

                                                     K'---L'---M'  (my-topic-branch)
                                                    /
                                           H---I---J  (next)
                                          /
                                 E---F---G  (dev)
                                /
                   A---B---C---D  (master)

# 3. Integration test: Squash and merge *my-topic-branch* in *next*. Features of *next* will be test as a whole.

                                           H---I---J---K''  (next, my-topic-branch)
                                          /
                                 E---F---G  (dev)
                                /
                   A---B---C---D  (master)

# 4. Packaging a minor release: Merge *dev* on *master*. Tag the *HEAD* of *master* with the next minor release label.

                                             H---I---J---K''  (next, my-topic-branch)
                                            /
                   A---B---C---D---E---F---G  (master, dev, tag_of_minor_release)

# 5. Packaging a major release: Merge *next* on *master*. Tag the *HEAD* of *master* with the next major release label.

                   A---B---C---D---E---F---G---H---I---J---K''  (master, dev, next, my-topic-branch, tag_of_major_release)
