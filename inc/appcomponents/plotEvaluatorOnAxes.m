function plotEvaluatorOnAxes(ax,evaluator)
    % plotEvaluatorOnAxes(ax,evaluator)

    % Velocity and velocity boundaries
    ax1 = subplot(2,2,1,'Parent',ax);
    plot(ax1,evaluator.time, evaluator.velocities);
    hold(ax1,'on');
    plot(   ax1,                                                        ...
            evaluator.time,                                             ...
            evaluator.maxVelocityFunction(evaluator.curvatures),        ...
            'k-.');
    hold(ax1,'off')
    title(ax1,'velocity')
    xlabel(ax1,'t [s]')
    ylabel(ax1,'v [m/s]')
    legend(ax1,'vehicle velocity', 'velocity limit')
    
    % Acceleration and acceleration limits
    acceleration    = diff(evaluator.velocities)./diff(evaluator.time);
    maxAcceleration = zeros(size(acceleration));
    maxDeceleration = maxAcceleration;
    for k=1:length(acceleration)
        maxAcceleration(k)  = evaluator.maxAccelerationFunction(evaluator.velocities(k));
        maxDeceleration(k)  = evaluator.maxDecelerationFunction(evaluator.velocities(k));
    end
    
    ax2 = subplot(2,2,2,'Parent',ax);
    plot( ax2,                                                          ...
        evaluator.time(1:end-1), acceleration,                          ...
        evaluator.time(1:end-1), maxAcceleration, 'k-.',                ...
        evaluator.time(1:end-1), maxDeceleration, 'k-.')
    title(ax2,'acceleration')
    xlabel(ax2,'t [s]')
    ylabel(ax2,'a [m/s^2]')
    legend(ax2,'vehicle acceleration', 'acceleration limit')
    
    % Velocity - acceleration
    ax3 = subplot(2,2,3,'Parent',ax);
    plot( ax3,                                                          ...
        evaluator.velocities(1:end-1), acceleration, '.',               ...
        evaluator.velocities(1:end-1), maxAcceleration, 'k.',           ...
        evaluator.velocities(1:end-1), maxDeceleration, 'k.')
    title(ax3,'velocity-acceleration')
    xlabel(ax3,'v [m/s]')
    ylabel(ax3,'a [m/s^2]')
    legend(ax3,'vehicle acceleration', 'acceleration limit')
    

end