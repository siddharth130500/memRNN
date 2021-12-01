classdef (Abstract) layer < handle
    % An abstract class for neural network layers
    %
    properties (Abstract)
        nlayer      % current layer number in the backend
        backend
        
        input_dim
        output_dim
        weight_dim
        
        act_name
    end
    
    methods (Abstract)
        y_out = call(obj, x_in);
        [dW, dx] = calc_gradients(obj, dy);
        initialize(obj);
    end
    
    methods (Access = protected )
        function [item, history] = history_pop(~, history)
            if size( history, 3) == 0
                error('Nothing in the layer history!');
            end
            
            item = history(:,:,end);
            history(:,:,end) = [];
        end

    end
    
end