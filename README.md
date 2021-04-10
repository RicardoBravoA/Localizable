# Localizable script

Tool to convert iOS .strings files to XML for Android

## Getting Started

Download the project from [Github](https://github.com/imhapi/localizable), the current branch of production is **master** and development is **develop**


## Initial setup

### Install xmlstarlet
```bash
brew install xmlstarlet
```

### Add permision

Go to the route `~/localizable/` and execute
```bash
chmod u+x ./localizable.sh
```

## Use

- Go to the route `~/localizable/` and add the **Localizable.strings** file

- Execute
```bash
./localizable.sh
```

- Check the strings.xml file, copy and paste it into your project

- Happy coding!


## License

Hapi Android is available under the MIT license. See the LICENSE file for more info.