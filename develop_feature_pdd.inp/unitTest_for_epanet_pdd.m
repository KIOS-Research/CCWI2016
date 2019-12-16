classdef unitTest_for_epanet_pdd < matlab.unittest.TestCase
    %unitTest_for_epanet_pdd: an Unit Test Class for Epanet_pdd-Matlab toolkit v1.0
    %   此处显示详细说明
    %   How to run
    %   t = unitTest_for_epanet_pdd()
    %   t.run
    properties
        obj
    end
    
    methods(TestClassSetup)
        function create_epanet_pdd(testCase)
            testCase.obj = epanet_pdd('net03.inp');
        end
    end
    methods(Test)
        function test_lib(testCase)
            test = libisloaded('epanet2');
            testCase.verifyTrue(test);
        end
%         function test_delete(testCase) % test pass
%             testCase.obj.delete
%             test = libisloaded('epanet2');
%             testCase.verifyFalse(test);
%         end
    end
    methods(TestClassTeardown)
        function unload(testCase)
            testCase.obj.delete
        end
    end
    methods(TestMethodSetup)
    end
    methods(TestMethodTeardown)
    end
end

