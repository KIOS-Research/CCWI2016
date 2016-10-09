%% Introduction to Toolkit
G = epanet('Net2.inp')

%% Properties
properties(G) % List of all available parameters
diameters = G.LinkDiameter % Link diameters from parameters
elevations = G.NodeElevations % Node elevations from parameters

%% Methods
methods(G) % List of all available methods
elevations = G.getNodeElevations([2 5]) % Node elevations for Nodes 2 & 5
diameters = G.getLinkDiameter % Link diameters from library
diameters(2)=18 % Change Link 2 diameter from 14 to 18
G.setLinkDiameter(diameters) % Set new link diameter
G.getLinkDiameter(2) % Confirms that Link 2 diameter is 18 
G.plot % Plots the network in a MATLAB Figure
A = G.getConnectivityMatrix % Create the connectivity matrix
func_list = G.getENfunctionsImpemented % List EPANET functions

%% Calling EPANET-MSX
H = G.getComputedHydraulicTimeSeries % Solve hydraulic dynamics in library
Q = G.getComputedQualityTimeSeries % Solve quality dynamics in library
B = G.getBinComputedAllParameters % Solve in library, create Binary file

%% EPANET-MSX
G.loadMSXFile('net2-cl2.msx') % Load MSX file with reactions
Q_msx = G.getMSXComputedQualityNode  % Compute water quality using MSX
G.plotMSXSpeciesNodeConcentration(3,1) % Plot MSX species in MATLAB Figure

%% Unload all libraries
G.unloadMSX % Unload EPANET-MSX
G.unload % Unload EPANET