## lingohub client

Client library and command-line tool to translate apps with [LingoHub](https://lingohub.com/).

### Install

``` bash
gem install lingohub
```

### Usage

#### Retrieving resource files

This is a simple example how we retrieve our resource files from lingohub in our _local repository_.  
We use the option `--locale <locale as filter>` for `translation:down` because our resource files are
stored in a folder per locale:

``` bash
lingohub resource:down --locale 'en' --directory config/locales/en --project 'lingohub' --all
lingohub resource:down --locale 'de' --directory config/locales/de --project 'lingohub' --all
```


### Maintainers

* Markus Merzinger (https://github.com/maerzbow)
* Helmut Juskewycz (https://github.com/hjuskewycz)

## License

MIT License. Copyright 2012 lingohub GmbH. https://lingohub.com
