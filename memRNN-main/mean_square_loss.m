classdef mean_square_loss < loss
    % Mean squre loss    
    properties
        calc_mode
        recurrent_mode
    end
    
    methods
        function obj = mean_square_loss( varargin )
            obj = obj@loss( varargin{:} );
        end
        
        function dys  = calc_delta(obj, ys, y_train )
            dys = y_train - ys;
            
            % Only output matters for some recurrent neural networks
            if strcmp( obj.recurrent_mode, 'last')
                dys(:,:,1:end-1) = 0;
            end
        end
        
        function loss = calc_loss(obj, ys, y_train )
            loss = 0;
            
            dys = obj.calc_delta( ys, y_train);
            
            for t = 1: size(ys, 3)
                %Only output matters for some recurrent neural networks
                if strcmp( obj.recurrent_mode, 'last') && t ~= size(ys, 3)
                    continue;
                end
            
                for n = 1: size(ys, 2)
                    loss = loss + dys(:, n, t)' * dys(:, n, t);
                end
            end
            
            if strcmp( obj.calc_mode, 'mean')
                loss = loss ./  size(ys, 2) ./ size(ys, 3);
            end
        end
    end
end