# Usage

### Installing

```
luarocks install kosmo
cd $YOUR_PROJECT_ROOT_DIR
lua -l kosmo.install
```
### Configuring

Edit the configuration files created under the cfg directory inside your project directory.


# Roadmap

* Implement `kosmo.install`
* Implement configurations
* Create abstraction modules which encapsulates [Aurora](../aurora/home) major functions
  * [aurora.template](../aurora/template)
  * [aurora.server](../aurora/server)
* Create rockspec and tag v1
* Upload to luarocks