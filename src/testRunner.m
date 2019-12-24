function pass = testRunner()
    % pass = testRunner()
    % Run all tests, issue a warning for each failed test

    % Init
    pass        = true;
    
    % Collect tests
    testDir     = dir('src/tests');
    testNames   = {testDir.name};
    testDir     = cell2mat({testDir.isdir});
    
    % Run tests
    for k=1:length(testNames)
        if ~testDir(k)
            
            testName    = testNames{k}(1:end-2);
            
            try
                result  = feval(testName);
                if ~result
                    failWarning(testName);
                    pass = false;
                else
                    passDisplay(testName);
                end
            catch exceptionType
                errorWarning(testName);
                pass = false;
            end
            
        end
    end
    
    if pass
        disp('ALL TESTS PASSED')
    end
    
    %% FUNCTION DEFINITIONS -----------------------------------------------
    function [] = passDisplay(functionName)
        disp([functionName,' passed'])
    end
    
    function [] = errorWarning(functionName)
        warning(['An error occured while running ',functionName])
    end
    
    function [] = failWarning(functionName)
        warning([functionName,' failed'])
    end

end