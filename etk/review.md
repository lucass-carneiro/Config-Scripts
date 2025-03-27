# Component review form

This file contains review criteria from [How to Review a new component](https://docs.einsteintoolkit.org/et-docs/How_to_Review_a_new_component). Whenever a question is posed, **yes** is indicated with `[x]` and **no** is indicated with `[ ]`.

Further notes may apply

# Formal Criteria

- [ ] Does the contribution have a README file in the [Cactus format](https://bitbucket.org/cactuscode/cactusbase/src/master/Boundary/README)? These could be parsed similar to [CactusCode's](http://www.cactuscode.org/documentation/Readme_Info.html) overview page.
  - [ ] Does it list authors of the component (optional but recommended)?
  - [ ] Does it list a maintainer who agrees to look after the component?
  - [ ] Does it list an open source license?
  - [ ] Does it give a brief description of what the component does?

- [ ] Does the contribution have a documentation.tex file that describes its functionality?
  - [ ] does it use the Cactus style file and follow the [Cactus standards](https://www.einsteintoolkit.org/usersguide/UsersGuide.html#x1-115000C1.8.4)?
  - [ ] does it set the "magic markers" `% START CACTUS THORNGUIDE` and `% END CACTUS THORNGUIDE` so that it can be included in the online [ThornGuide](https://www.einsteintoolkit.org/documentation/ThornGuide.php)
  - [ ] does the documentation build when running `make <THORNNAME>-ThornDoc` and `make <THORNNAME>-ThornDocHTML` (the latter requires [htlatex](https://packages.debian.org/bookworm/texlive-plain-generic))

- [ ] does it have test cases in its tests directory?
- [ ] are there sensible descriptions of all parameters, scheduled routines and grid variables in param.ccl, schedule.ccl and interface.ccl?

# Quality Criteria

- [ ] Has there been a publication using the component? This settles the "sufficient quality" criteria
- [ ] Has there been public interest in the component? For example voiced in the inclusion ticket. This settles the "current interest" criteria
- [ ] Does the code satisfy the criteria laid out in [How to Review a Patch](https://docs.einsteintoolkit.org/et-docs/How_to_Review_a_Patch)
  - [ ] Is it clear and easy to understand?
  - [ ] Is it sufficiently commented (using English language comments)?
  - [ ] Is there "dead code" or are there large commented out sections?
  - [ ] Are there obvious bugs? Do you notice any corner (or not so corner) cases missing?

- [ ] Are externally visible symbols, unless in a C++ namespace or Fortran 90 module in which case the namespace or module name needs to carry the prefix, prefixed with the thorn name? I.e. `MyThorn_DoSomthing` rather than `DoSomething`. See [Cactus Users Guide](https://www.einsteintoolkit.org/usersguide/UsersGuide.html#x1-141000C1.9.7) for rationale and further details.
- [ ] Does the code compile?
- [ ] Does it run?
- [ ] Does it (obviously) break anything else already in the Einstein Toolkit?

- [ ] Do the test cases adhere to [Adding a test case](https://docs.einsteintoolkit.org/et-docs/Adding_a_test_case)
  - [ ] Do the test cases finish in a reasonable amount of time (less than 10s per test, less than 2min for the whole component)?
  - [ ] Are the test cases "small" (less than 1GB of memory, preferably much less)
  - [ ] Do the tests cover important functionality? Science wise? Lines of code wise (using gcov)?

# Correctness criteria

Correctness is not part of the review, it having been used in peer reviewed publications is taken as sufficient evidence of correctness.

# Optional criteria

A new component reviewer can suggest that the component provides a gallery example. This will have, at least, two advantages:
  1. provide a regularly tested (every 6 months), fully worked out example of the code
  2. increase visibility of new component since it is featured on the Einstein Toolkit home page front page
