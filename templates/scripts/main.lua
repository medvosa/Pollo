local js = require "js"
local window = js.global

package.loadlib("https://cdn.jsdelivr.net/npm/vue@2.5.13/dist/vue.js", "*")
package.loadlib("https://unpkg.com/vuesax@4.0.1-alpha.16/dist/vuesax.min.js","*")

local Object = dofile("https://gist.githubusercontent.com/daurnimator/5a7fa933e96e14333962093322e0ff95/raw/8c6968be0111c7becc485a692162ad100e87d9c7/Object.lua").Object

window.app = js.new(js.global.Vue, Object{
	el = "#mainApp";
	methods = Object{
        login= function ()
            window.app.isLogin = true
        end;
        register =  function ()
            window.app.isRegister = true
        end;
        closeForm=  function ()
            window.app.isLogin = false
            window.app.isRegister = false
        end;
    };
	data = Object{
        isLogin = false;
        isRegister = false;
        passwordRepeat='';
        password='';
        test=window.arr(0,1,2,3);
        email='';
	}
})

