classdef sim_array1 < memristor_array
    % Simulated subarray
    % Assumes 0 wire resistance, all devices identical, 100% yield, 0 noise
    % Construction syntax: OBJ = SIM_ARRAY1(G0, UPDATE_FUN, GMIN, GMAX)
    properties
        net_size
        conductances
        gmin
        gmax

    end
    methods
        %%
        function obj = sim_array1(g0, gmin, gmax)
            % OBJ = SIM_ARRAY1(G0, UPDATE_FUN, GMIN, GMAX)
            % creates a simulated memristor array.
            % G0 is the initial weight matrix, and determines the size of
            % the array. G0 can also be a cell array holding:
            %   {'random' SIZE MIN MAX}     Generates uniformly distributed
            %                               random weights between MIN and
            %                               MAX
            %   {'fixed' SIZE VALUE}        Initializes all weights to
            %                               exactly VALUE
            % UPDATE_FUN gives delta-G as a function of G, V_in, and V_trans
            % GMIN defaults to 0
            % GMAX defaults to Inf
            % The pulse width is fixed for now, but number of pulses may
            % eventually be something we can tune.
            
            switch nargin
                case {0 1}
                    error('Not enough input arguments')
                case 2
                    gmin = 0;
                    gmax = Inf;
                case 3
                    %gmax = Inf;
            end
            
            obj.gmin = gmin;
            obj.gmax = gmax;
            obj.conductances = obj.generate_g0(g0);
            obj.net_size = size(obj.conductances);

        end
        %%
        function conductances = read_conductance(obj,varargin)
            % CONDUCTANCES = OBJ.READ_CONDUCTANCE() returns the conductance
            % values stored in the array. This is noise-free reading.
            % Optional input arguments can be entered but are ignored.
            conductances = obj.conductances;
        end
        %%
        function update_conductance(obj, V_in, V_out)
            V_in = obj.expand(V_in);
            V_out = obj.expand(V_out);
            
            if any(V_out(:)) && any(V_in(:))
                warning('Did you mean to SET and RESET both in one call?')
                % Two-vector SET is not supported for this class.
                % condition could be if any(V_out(:) & V_IN(:))
            end
            
            % Get conductance:
            
            G = obj.conductances(:);
            
            % Do the updates:
            if any(V_in(:))
                disp('set pulse');
                VP = V_in(:);
                for k = 1:size(G)
                    g = G(k);
                    Vp = VP(k);
                    if Vp > 0
        %                 g = g+obj.update_fun(g,V_in(:),V_trans(:));
                        if g>= 3.16e-6 && g < 5.62e-6 %1
                            c = [1.55e-4,-0.47,-3.851,9.369,10.4];
                        elseif g >= 5.62e-6 && g < 10e-6 %2
                            c = [1.55e-4,-0.47,-3.769,7.512,8.419];
                        elseif g>= 10e-6 && g < 17.8e-6 %3
                            c = [1.55e-4,-0.47,-3.729,6.801,7.582];
                        elseif g>= 17.8e-6 && g < 31.6e-6 %4
                            c = [1.55e-4,-0.47,-3.517,6.180,6.851];
                        elseif g>= 31.6e-6 && g < 56.2e-6 %5
                            c = [1.55e-4,-0.47,-3.426,5.946,6.558];
                        elseif g>= 56.2e-6 && g < 100e-6 %6
                            c = [1.55e-4,-0.47,-3.373,5.005,5.792];
                        elseif g>= 100e-6 && g < 178e-6 %7
                            c = [1.55e-4,-0.47,-3.422,4.936,5.840];
                        elseif g < 315e-6 %8
                            c = [1.55e-4,-0.47,-3.572,4.864,5.785];
                        end
                        tp = 100;
                        if k==1 
                            disp(g(k)*1e6);
                        end
                        deltag = c(1)*(1 - tanh(  c(2)*(log(tp) - c(3))  ))*(tanh(    c(4)*Vp - c(5)  ) + 1);
                        g = g + deltag;
                        if k==1
                            fprintf("%f %f %f %f %f",Vp, c(1),c(2),c(3),c(4));
                            disp(deltag*1e6);
                            disp(g(k)*1e6);
                        end
                        G(k) = g;
                    end
                end
            end
            if any(V_out(:))
               disp('reset pulse') %reset pulse       
%                 g = g+obj.update_fun(g,-V_out(:),V_trans(:));
               VP = V_out(:);
               for k = 1:size(G)
                    g = G(k);
                    Vp = VP(k);
                    if Vp < 0
                        if g>= 3.16e-6 && g < 5.62e-6 %1
                            c = [-0.89e-4,0.89,8.96,6.2,-10.90];
                        elseif g >= 5.62e-6 && g < 10e-6 %2
                            c = [-0.89e-4,0.51,6.88,6.2,-8.61];
                        elseif g>= 10e-6 && g < 17.8e-6 %3
                            c = [-0.89e-4,0.34,4.93,6.2,-8.14];
                        elseif g>= 17.8e-6 && g < 31.6e-6 %4
                            c = [-0.89e-4,0.25,3.63,6.2,-7.77];
                        elseif g>= 31.6e-6 && g < 56.2e-6 %5
                            c = [-0.89e-4,0.23,2.91,6.2,-7.42];
                        elseif g>= 56.2e-6 && g < 100e-6 %6
                            c = [-0.89e-4,0.21,2.33,6.2,-7.30];
                        elseif g>= 100e-6 && g < 178e-6 %7
                            c = [-0.89e-4,0.22,1.93,6.2,-7.10];
                        else %8
                            c = [-0.89e-4,0.28,1.68,6.2,-7.00];
                        end
                        tp = 100;
                        if k==1 
                            disp(g(k)*1e6)
                        end
                        deltag = c(1)*(      -1 - tanh(  c(2)*(log(tp) - c(3))  )     )*(tanh(    c(4)*Vp - c(5)  ) - 1);
                        g = g + deltag;
                        if k==1
                            fprintf("%f %f %f %f %f",Vp, c(1),c(2),c(3),c(4));
                            disp(deltag*1e6);
                            disp(g(k)*1e6);
                        end
                        G(k) = g;
                    end
               end
            end
            % Enforce the maxima:
            G(G<obj.gmin) = obj.gmin;
            G(G>obj.gmax) = obj.gmax;
            disp(obj.gmin);
            disp(obj.gmax);
            % Save result:
            obj.conductances(:) = G;
            File = matfile('g_total.mat', 'Writable', true); 
            File.g(:,:,end+1) = obj.conductances;
        end

%%        
        function I_out = read_current(obj, V_in, varargin)
            % Optional arguments can be entered but are ignored
            if iscell(V_in)
                try
                    cell2mat(V_in);
                catch
                    error('Unrecognized input format')
                end
            end
            
            I_out = obj.conductances'*V_in;
        end
        
        % Other methods to write: Some sort of testing, probably.
        % Maybe also a "set-weights" type of thing, for initialization
        
        %%
        function b = expand(obj,a)
            % this function attempts to read minds: Did you mean _
            % Does its best to expand things.
            if all(size(a) == obj.net_size)
                b = a;
            elseif isscalar(a)
                b = repmat(a,obj.net_size);
            elseif strcmpi(a,'GND')
                b = zeros(obj.net_size);
            elseif any(size(a) == obj.net_size)
                if iscolumn(a) && length(a) == obj.net_size(1)
                    b = repmat(a,1,obj.net_size(2));
                elseif isrow(a) && length(a) == obj.net_size(2)
                    b = repmat(a,obj.net_size(1),2);
                else
                    error('Not sure how to expand this input')
                end
            else
                error('Not sure how to expand this input')
            end
        end
        %%
        function g0 = generate_g0(~,g0)
            % Used to automatically generate initial weight matrices.
            % I'll add more options to them as they become useful.
%             if isnumeric(g0)
%                 return
%             elseif iscell(g0) % Case where it's a cell
%                 switch lower(g0{1})
%                     case 'random'
%                         % Second entry is size, third is minval, 4th is
%                         % maxval.
%                         g0 = rand(g0{2})*(g0{4}-g0{3})+g0{3};
%                     case 'fixed'
%                         % Second entry is size, third is value
%                         g0 = zeros(g0{2})+g0{3};
%                 end
%             end
%             File = matfile('init_conductances.mat', 'Writable', true); 
%             File.c = g0;
              load('init_conductances_v2_1.mat');
              g0 = c;
              
        end
    end
end