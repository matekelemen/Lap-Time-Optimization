function plotEvaluator(evaluator)
    % plotEvaluator(evaluator)

    % Velocity and velocity boundaries
    subplot(2,2,1)
    plot(evaluator.time, evaluator.velocities);
    hold on
    plot(   evaluator.time,                                             ...
            evaluator.maxVelocityFunction(evaluator.curvatures),        ...
            'k-.');
    hold off
    title('velocity')
    xlabel('t [s]')
    ylabel('v [m/s]')
    legend('vehicle velocity', 'velocity limit')
    
    % Acceleration and acceleration limits
    acceleration    = diff(evaluator.velocities)./diff(evaluator.time);
    maxAcceleration = zeros(size(acceleration));
    maxDeceleration = maxAcceleration;
    for k=1:length(acceleration)
        maxAcceleration(k)  = evaluator.maxAccelerationFunction(evaluator.velocities(k));
        maxDeceleration(k)  = evaluator.maxDecelerationFunction(evaluator.velocities(k));
    end
    
    subplot(2,2,2)
    plot(                                                               ...
        evaluator.time(1:end-1), acceleration,                          ...
        evaluator.time(1:end-1), maxAcceleration, 'k-.',                ...
        evaluator.time(1:end-1), maxDeceleration, 'k-.')
    title('acceleration')
    xlabel('t [s]')
    ylabel('a [m/s^2]')
    legend('vehicle acceleration', 'acceleration limit')
    
    % Velocity - acceleration
    subplot(2,2,3)
    plot(                                                               ...
        evaluator.velocities(1:end-1), acceleration, '.',               ...
        evaluator.velocities(1:end-1), maxAcceleration, 'k.',           ...
        evaluator.velocities(1:end-1), maxDeceleration, 'k.')
    title('velocity-acceleration')
    xlabel('v [m/s]')
    ylabel('a [m/s^2]')
    legend('vehicle acceleration', 'acceleration limit')
    

end