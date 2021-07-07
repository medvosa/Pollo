local js = require "js"
local window = js.global

package.loadlib("/static/vue.js", "*")
package.loadlib("/static/vuesax.min.js","*")

local Object = dofile("/static/lib/Object.lua").Object


isPollsToggled = false;

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
        toggle = function()
            --print('toggle')
            isPollsToggled = not isPollsToggled;
            if isPollsToggled then
                window.app.togglePollsText="Свернуть";
                --print(window.document:getElementsByClassName('user-index-polls')[0].style.display)
                window.document:getElementsByClassName('user-index-polls')[0].style.display='grid'
            else
                window.app.togglePollsText="Развернуть";
                --print(window.document:getElementsByClassName('user-index-polls')[0].style.display)
                window.document:getElementsByClassName('user-index-polls')[0].style.display='none'
            end
        end
    };
	data = Object{
        isLogin = false;
        togglePollsText="Развернуть";
        isRegister = false;
        passwordRepeat='';
        password='';
        isError=false;
        test=window.arr(0,1,2,3);
        email='';
        errorText='';
	}
})


if window.location.hash=="#errorlogin" then
    window.app:login()
    window.app.isError=true;
end

if window.location.hash=="#errorreg_invalid_mail" then
    window.app:register()
    window.app.isError=true;
    window.app.errorText='введен неверный email';
end

if window.location.hash=="#errorreg_exists" then
    window.app:register()
    window.app.isError=true;
    window.app.errorText='пользователь с таким email уже существует';
end

if window.location.hash=="#errorreg_not_match" then
    window.app:register()
    window.app.isError=true;
    window.app.errorText='пароль и повтор пароля должны совпадать';
end

if window.location.hash=="#errorreg_easy_password" then
    window.app:register()
    window.app.isError=true;
    window.app.errorText='пароль слишком простой';
end

if window.location.hash=="#tologin" then
    window.app:login()
end

if window.location.hash=="#toreg" then
    window.app:register()
end

