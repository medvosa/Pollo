{% raw %}
local js = require "js"
local window = js.global;
local Object = dofile("https://gist.githubusercontent.com/daurnimator/5a7fa933e96e14333962093322e0ff95/raw/8c6968be0111c7becc485a692162ad100e87d9c7/Object.lua").Object
local Inspect = dofile("https://raw.githubusercontent.com/kikito/inspect.lua/master/inspect.lua")

js.global.Vue:component('question', Object{
    components= Object{
      apexchart= window.VueApexCharts;
    },
    data = function(self)
        print(self.question.answers)
        return Object{
            text='';
            series= self.question.data;--window:arr(44, 55, 13, 43);
            chartOptions= Object{
                chart= Object{
                    width= 380;
                    type= 'pie';
                };
                labels= self.question.answers;--window:arr('Team A', 'Team B', 'Team C', 'Team D', 'Team E'),
                responsive= window:arr(Object{
                    breakpoint= 480,
                    options= Object{
                        chart= Object{
                            width= 200
                        },
                        legend= Object{
                            position= 'bottom'
                        }
                    }
                })
            },
        };
    end;
    props = window:arr(
        'question'
    ),
    methods = Object{

    },
    template = [[
        <div class="poll-stats-card">
            <h3 class="bp0"> {{ question.text }}</h3>
            <div id="chart">
                <apexchart type="pie" width="380" :options="chartOptions" :series="series"></apexchart>
            </div>
        </div>
    ]]
});

local Object = dofile("https://gist.githubusercontent.com/daurnimator/5a7fa933e96e14333962093322e0ff95/raw/8c6968be0111c7becc485a692162ad100e87d9c7/Object.lua").Object


window.app = js.new(js.global.Vue,Object{
    el='#t2';
    methods = Object{

    };
    data=Object{
        arr=window.questions;

    }
})

local Vue = window.Vue;
local this;

{% endraw %}