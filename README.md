Procfile Upstart Exporter
=========================

Export [Procfile][procfile] entries to [Upstart][upstart] jobs.

Y U no [Foreman][foreman]?
--------------------------

I'm aware of [Foreman's][foreman] [exporting capabilities][foreman-export] but
I find them lacking for the following reasons:

1. Templates have [long stading issues][foreman-upstart-template-issues]. This
   could be solved with custom templates.
2. Generated [Upstart][upstart] jobs are placed in the same folder. It would
   be nice to have a structure like the following:

   ```
   /etc/init
   ├── application
   │   ├── background-workers.conf
   │   └── web.conf
   └── application.conf
   ```

   This makes it easy to delete the application's job entries and looks good.
   Specific processes could be started/stopped with
   `<action> <application>/<process>`. For example, start the job configured
   in `/etc/init/application/web` with `start application/web`.

[Procfile Upstart Exporter][procfile-upstart-exporter] makes this possible.


Install
-------

[Procfile Upstart Exporter][procfile-upstart-exporter] is a
[Ruby gem][ruby-gem]. Install it with `gem install procfile-upstart-exporter`.

Usage
-----

### Create [Upstart][upstart] jobs configuration

```console
# procfile-upstart-exporter export                                            \
    --application <application>                                               \
    --procfile <path-to-procfile>                                             \
    --log <path-to-log>                                                       \
    --environment <path-to-dotenv-file>                                       \
    --user <user-to-run-job>                                                  \
    --path <path-where-upstart-jobs-will-be-created>
```

### Delete [Upstart][upstart] jobs configuration

```console
# procfile-upstart-exporter destroy                                           \
    --application <application>                                               \
    --path <path-where-upstart-jobs-are-found>
```

License
-------

Copyright © 2013 Das Dad

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


[procfile]: http://ddollar.github.io/foreman/#PROCFILE
[upstart]: http://upstart.ubuntu.com/
[foreman]: https://github.com/ddollar/foreman
[foreman-export]: http://ddollar.github.io/foreman/#EXPORTING
[foreman-upstart-template-issues]: https://github.com/ddollar/foreman/issues/97
[procfile-upstart-exporter]: https://github.com/dasdad/procfile-upstart-exporter
[ruby-gem]: http://rubygems.org/
