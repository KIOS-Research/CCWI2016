classdef epanet_pdd < handle
    %epanet_pdd-Matlab Toolkit v1.0: A Matlab Class for EPANET, EPANET-MSX AND EPANET-Matlab Toolkit v2.1
    %libraries
    %   Notes:
    %   1. The defaults settings for flow Unit is LPS, so the Units in the
    %   inp file should be change to LPS.---2019-7-15
    %   2. The extened period simulations feature is waiting to
    %   add.---2019-7-15
    %
    %   How to run:
    %   d = epanet_pdd('net03.inp');
    %   d.createAllNodePDD('net03PDD.inp')
    %   d.delete;
    %
    %   To set global service head
    %   d.ServiceHead = 20;(Unit:meter)
    %
    %   To set global minimum head
    %   d.MinimumHead = 0;(Unit:meter)
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
        Epanet
    end
    properties
        ServiceHead = 20
        MinimumHead = 0
        G = 9.8;%GravitationalAcceleration
        Diameter_large = 1000;%(mm)
        Diameter_arbitrary = 150;%(mm)
        Length_short = 0.01 ;% (m)
    end
    properties
        NodesInfo
        LinksInfo
    end
    properties
        FCVs
        TCVs
        DummyNodeAs
        DummyNodeBs
        Reservoirs
    end

    
    methods
        function obj = epanet_pdd(varargin)
            %Constructor of the EPANET_PDD Class
            %   Costructor of the EPANET class
            switch nargin
                case 1
                obj.Epanet = epanet(varargin{1});
%                 obj.Epanet = epanet(varargin{1},'BIN');
                case 2
                obj.Epanet = epanet(varargin{1},varargin{2});
                case 3
                obj.Epanet = epanet(varargin{1},varargin{2},varargin{3});
            end  
            obj.getInfo
        end
        function delete(obj)
            obj.Epanet.unload;
        end
    end
    methods
        function createAllNodePDD(obj,InpFile)
            JunctionCount = obj.NodesInfo.BinNodeJunctionCount;
            for i = 1:JunctionCount
                obj.addPDDElements(i);
            end
            obj.saveInp(InpFile);
        end
    end
    methods
        function getInfo(obj)
            obj.NodesInfo = obj.Epanet.getBinNodesInfo;
            obj.LinksInfo = obj.Epanet.getBinLinksInfo;
        end
        function addPDDElements(obj,NodeIndex,NodeID)
            % NodeID is the ID of  user junction which is needed to add elements
%             keyboard
            switch nargin
                case 1
%                     disp(['nargin=',num2str(nargin)])
                    return
                case 2
                    NodeID = obj.NodesInfo.BinNodeJunctionNameID(NodeIndex);
%                     disp(NodeID)
%                     return
                case 3
                    if isempty(NodeIndex)
                        NodeIndex = obj.Epanet.getBinNodeIndex(NodeID);% the index of the junction
                    else
                        
                    end
            end            
            NodeX = obj.NodesInfo.BinNodeCoordinates{1}(NodeIndex);
            NodeY = obj.NodesInfo.BinNodeCoordinates{2}(NodeIndex);
            NodeBaseDemand = obj.NodesInfo.BinNodeJunctionsBaseDemands(NodeIndex);
            NodeElevation = obj.NodesInfo.BinNodeJunctionElevation(NodeIndex);
            K_tcv = (obj.G*pi^2*obj.ServiceHead*obj.Diameter_arbitrary^4)*(10^-6)/(8*NodeBaseDemand^2); 
            % bug: only account for LPS unit and single period simulations
            NodeID = char(NodeID);
            % information for DummyNodeA
            DummyNodeA.x = NodeX;
            DummyNodeA.y = NodeY;
            DummyNodeA.ID = ['A',NodeID];
            DummyNodeA.Elevation = NodeElevation+obj.MinimumHead;
            DummyNodeA.BaseDemand = 0;
            % information for DummyNodeB
            DummyNodeB.x = NodeX;
            DummyNodeB.y = NodeY;
            DummyNodeB.ID = ['B',NodeID];
            DummyNodeB.Elevation = NodeElevation+obj.MinimumHead;
            DummyNodeB.BaseDemand = 0;
            % information for Reservoir
            Reservoir.x = NodeX;
            Reservoir.y = NodeY;
            Reservoir.ID = ['R',NodeID];
            Reservoir.Elevation = NodeElevation+obj.MinimumHead;
            % information for FCV
            FCV.Diameter = obj.Diameter_large;
            FCV.fromNode = NodeID;
            FCV.toNode = DummyNodeA.ID;
            FCV.Setting = NodeBaseDemand;
            FCV.ID = ['F',NodeID];
            FCV.Code = 'FCV';
            % information for TCV
            TCV.Diameter = obj.Diameter_arbitrary;
            TCV.Setting = K_tcv;
            TCV.fromNode = DummyNodeA.ID;
            TCV.toNode = DummyNodeB.ID;
            TCV.ID = ['T',NodeID];
            TCV.Code = 'TCV';
            
            % information for CV--Pipe
            CV.Diameter = obj.Diameter_large;
            CV.Length = obj.Length_short;
            CV.fromNode = DummyNodeB.ID;
            CV.toNode = Reservoir.ID;
            CV.ID = ['C',NodeID];   
            CV.Code = 'PIPE';
            
            % add element
            % add junction A 
            NodeA_index = obj.Epanet.addNodeJunction(DummyNodeA.ID);
            obj.Epanet.setNodeElevations(NodeA_index,DummyNodeA.Elevation);
            obj.Epanet.setNodeBaseDemands(NodeA_index,DummyNodeA.BaseDemand);
            obj.Epanet.setNodeCoordinates(NodeA_index,[DummyNodeA.x,DummyNodeA.y]);
            % add FCV
            FCV_index = obj.Epanet.addLinkValveFCV(FCV.ID,FCV.fromNode,FCV.toNode);
            obj.Epanet.setLinkDiameter(FCV_index,FCV.Diameter);
            obj.Epanet.setLinkInitialSetting(FCV_index,FCV.Setting);
            % add junction B 
            NodeB_index = obj.Epanet.addNodeJunction(DummyNodeB.ID);
            obj.Epanet.setNodeElevations(NodeB_index,DummyNodeB.Elevation);
            obj.Epanet.setNodeBaseDemands(NodeB_index,DummyNodeB.BaseDemand);
            obj.Epanet.setNodeCoordinates(NodeB_index,[DummyNodeB.x,DummyNodeB.y]);
            % add TCV
            TCV_index = obj.Epanet.addLinkValveTCV(TCV.ID,TCV.fromNode,TCV.toNode);
            obj.Epanet.setLinkDiameter(TCV_index,TCV.Diameter);
            obj.Epanet.setLinkInitialSetting(TCV_index,TCV.Setting);
            % add Reservoir
            R_index = obj.Epanet.addNodeReservoir(Reservoir.ID);
            obj.Epanet.setNodeCoordinates(R_index,[Reservoir.x,Reservoir.y]);
            obj.Epanet.setNodeElevations(R_index,Reservoir.Elevation);
            % add Pipe--CV
            newRoughness = 100;
            CV_index = obj.Epanet.addLinkPipeCV(CV.ID,CV.fromNode,CV.toNode);
            obj.Epanet.setLinkDiameter(CV_index,CV.Diameter);
            obj.Epanet.setLinkLength(CV_index,CV.Length);
            obj.Epanet.setLinkRoughnessCoeff(CV_index,newRoughness);   
            % set Junction Base Demand 0
            obj.Epanet.setNodeBaseDemands(NodeIndex,0);
        end
        function saveInp(obj,fileName)
            obj.Epanet.saveInputFile(fileName);
        end
    end
end

