{% raw %}
    local js = require "js"
    local window = js.global

    package.loadlib("https://cdn.jsdelivr.net/npm/vue@2.5.13/dist/vue.js", "*")
    package.loadlib("https://unpkg.com/vuesax@4.0.1-alpha.16/dist/vuesax.min.js","*")

    local Object = dofile("https://gist.githubusercontent.com/daurnimator/5a7fa933e96e14333962093322e0ff95/raw/8c6968be0111c7becc485a692162ad100e87d9c7/Object.lua").Object

    Vue = js.global.Vue
    console = js.global.console;

    Vue:component('question', Object{
        data=function()
            return Object{
                answers=window:arr('да','нет');
                ansVar="";
            };
        end;
        props= window:arr(
            'num',
            'question'
        );
        methods=Object{
            remove = function(self)
                print(math.floor(self.num+1))
                print(window.app.questions:splice(math.floor(self.num),1))
                --table.remove(window.app.questions,math.floor(self.num+1))
            end;
            addAnsVar=function(self)
                print(self.answers)
                print(self.ansVar)
                self.answers:push(self.ansVar)
                self.ansVar=""
            end
        };
        template=[[
            <div v-bind:id="'wr'+num">
                <h3 class="bp0">Вопрос {{ num + 1 }}</h3>
                <svg xmlns="http://www.w3.org/2000/svg" width="17.707" height="17.707" viewBox="0 0 17.707 17.707" @click="remove" style="float: right; transform: translate(30px, 11px);">
                    <g transform="translate(0.354 0.354)">
                        <line style="fill:none;stroke:#000;" x2="17" y2="17"/>
                        <line style="fill:none;stroke:#000;" x2="17" y2="17" transform="translate(17) rotate(90)"/>
                    </g>
                </svg>
                <vs-input v-model="question.caption"/>
                <div class="buttons-wrapper">
                    <vs-button flat dark color="#F7F7F7" size="large" v-for="i in answers" >{{i}}</vs-button>

                    <vs-input placeholder="другое" v-on:change="addAnsVar" v-model="ansVar"></vs-input>
                </div>
            </div>
        ]]
    });

    Vue:component('question-template', Object{
        data = function()
            return Object{
                text='';
            };
        end;
        props = window:arr(
            'num'
        ),
        methods = Object{
            addQuestion = function(self,event)
                window.app:addQuestion(event.target.value);
                self.text='';
            end;
        },
        template = [[
            <div>
                <h3 class="bp0">Вопрос {{ num + 1 }}</h3>
                <vs-input v-on:change="addQuestion" v-model="text"></vs-input>

            </div>
        ]]
    });


window.app = js.new(js.global.Vue, Object{
	el = "#mainApp";
	methods = Object{
        save=function()
            print('save');
            for i =1, #window.app.questions do
                print(window.app.questions[i-1].caption)
            end
            js.global:fetch('/create', Object{
                method = "POST",
                headers =  Object{
                    ['Accept'] = 'application/json',
                    ['Content-Type'] = 'application/json'
                },
                body = window.JSON:stringify(Object{
                    imageUrl=window.app.imageUrl,
                    title = window.app.title,
                    questions = window.app.questions,
                })
            })
        end;
        addQuestion=function(t,caption)
            print(caption);
            window.app.questions:push(Object{caption=caption});
        end
    };
	data = Object{
        imageUrl="";
        title='';
        questions=window:arr();
	}
})
{% endraw %}