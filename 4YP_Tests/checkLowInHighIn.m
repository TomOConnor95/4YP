function initialParams = checkLowInHighIn(initialParams)
if initialParams(1) > initialParams(4)
    temp = initialParams(1);
    initialParams(1) = initialParams(4);
    initialParams(4) = temp;
end
if initialParams(2) > initialParams(5)
    temp = initialParams(2);
    initialParams(2) = initialParams(5);
    initialParams(5) = temp;
end
if initialParams(3) > initialParams(6)
    temp = initialParams(3);
    initialParams(3) = initialParams(6);
    initialParams(6) = temp;
end
end