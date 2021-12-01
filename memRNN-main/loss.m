classdef (Abstract) loss < handle
    % An abstract class for loss 
    %
    properties (Abstract)
        calc_mode
        recurrent_mode
    end
    methods
        function obj = loss( varargin )
           
            okargs = {'calc_mode', 'recurrent_mode'};
            defaults = {'sum', 'all'};
            [obj.calc_mode, obj.recurrent_mode] =...
                internal.stats.parseArgs(okargs, defaults, varargin{:});
        end
    end
    
    methods (Abstract)
        dys  = calc_delta(~, ys, y_train );
        loss = calc_loss(~, ys, y_train );
    end
end