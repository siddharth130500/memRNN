% Copyright (c) 2018, 
% Department of Electrical and Computer Engineering, University of Massachusetts Amherst
% All rights reserved.
% 
% Created by 
%     Can Li (Email: me at ilican dot com
%             Website: http://ilican.com)
%     Daniel Belkin, Zhongrui Wang, Wenhao Song
% 
% PI: Prof. Qiangfei Xia (Email: qxia at umass dot com
%                         Website: http://nano.ecs.umass.edu)
%     Prof. J. Joshua Yang (Email: jjyang at umass dot com
%                         Website: http://www.ecs.umass.edu/ece/jjyang/)
% 
% LICENSE
% 
% The MIT License (MIT)
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.


classdef view < handle
    properties
        DEBUG = 0;
        DRAW_PLOT = 0;
        
        data_plot;
    end
    
    methods
        function obj = view()
            obj.data_plot = [];
        end
        
        function print(obj, string ) 
            if obj.DEBUG
                disp( string );
            end
        end 
        
        function plot(obj, value )
            
            obj.plot_loss( value );
        end
        
        function plot_loss(obj, value)
            obj.data_plot = [obj.data_plot value];
            
            if obj.DRAW_PLOT
                figure(1);
                plot(obj.data_plot);
%                 set(gca, 'YScale', 'log');
                
                xlabel('No of updates');
                ylabel('Loss');
                
                drawnow;
            end  
        end
    end
end