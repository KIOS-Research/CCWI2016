classdef epanet_pdd < epanet
    %epanet_pdd v1.0: A Matlab Class for EPANET, EPANET-MSX AND EPANET-Matlab Toolkit v2.1
    %libraries
    %
    %
    %   How to run:
    %   
    %   EPANET is software that models water distribution piping systems
    %   developed by the US EPA and provided under a public domain licence.
    %   This Matlab Class serves as an interface between Matlab and
    %   EPANET/EPANET-MSX, to assist researchers and the industry when
    %   solving problems related with water distribution systems.
    %
    %   EPANET and EPANET-MSX were developed by the Water Supply and Water
    %   Resources Division of the U.S. Environmental Protection Agency's
    %   National Risk Management Research Laboratory. EPANET is under the
    %   Public Domain and EPANET-MSX under GNU LGPL.
    %
    %   The latest EPANET files can downloaded at:
    %   https://github.com/OpenWaterAnalytics/epanet
    %
    %   EPANET-Matlab Class was developed by KIOS Research Center for 
    %   Intelligent Systems and Networks, University of Cyprus
    %   (www.kios.org.cy)
    %
    %   The latest EPANET-Matlab Class files can downloaded at:
    %   https://github.com/KIOS-Research/CCWI2016
    %
    %   Inspired by:
    %   EPANET-Matlab Wrappers (Jim Uber)
    %   EPANET-Matlab Toolkit (Demetrios Eliades)
    %   getwdsdata (Philip Jonkergouw)  
    %   Paez, D., Suribabu, C. R., & Filion, Y. (2018). Method for extended 
    %     period simulation of water distribution networks with pressure  
    %     driven demands.Water resources management, 32(8), 2837-2846.
    %
    %   epanet_pdd Licence:
    %
    %   Copyright Zhao Han, College of Architecture and Civil Engineering,
    %   Beijing Universiy of Technology
    %   
    %
    %   Licensed under the GPL, Version 3.0 
    %   You may not use this work except in compliance with the Licence.
    %   You may obtain a copy of the Licence at:
    %
    %   http://www.gnu.org/licenses/gpl-3.0.html
    %
    %   Unless required by applicable law or agreed to in writing, software
    %   distributed under the Licence is distributed on an "AS IS" basis,
    %   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
    %   implied. See the Licence for the specific language governing
    %   permissions and limitations under the Licence.
    properties
        Property1
    end
    
    methods
        function obj = untitled(inputArg1,inputArg2)
            %UNTITLED 构造此类的实例
            %   此处显示详细说明
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 此处显示有关此方法的摘要
            %   此处显示详细说明
            outputArg = obj.Property1 + inputArg;
        end
    end
end

