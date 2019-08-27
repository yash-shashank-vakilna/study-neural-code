function result = round2even(x,Ndigits)

% The round2even function performs round to even, which is different from round to 
% larger.  The return value is the number closest to the value of expression, with 
% the appropriate number of decimal places. If expression is exactly halfway between 
% two possible rounded values, the function returns the possible rounded value 
% whose rightmost digit is an even number. (In a round to larger function, a number 
% that is halfway between two possible rounded values is always rounded to the 
% larger number.)
%
% Note: Round to even is a statistically more accurate rounding 
% algorithm than round to larger.
%
% Note: Round to even is sometimes called banker's rounding.
%
% The following example demonstrates how rounding to even works: 
% 
% Dim var1, var2, var3, var4, var5
% var1 = round2even(1.5)      :  var1 contains 2
% var2 = round2even(2.5)      :  var2 contains 2
% var3 = round2even(3.5)      :  var3 contains 4
% var4 = round2even(0.985, 2) :  var4 contains 0.98
% var5 = round2even(0.995, 2) :  var5 contains 1.00
% var6 = round2even(-5.5)     :  var6 contains -6
% var7 = round2even(-4.5)     :  var6 contains -4
%
%===================================================================================
% INPUTS:
%
%       x                     input value(s) to be rounded
%       Ndigits               number of digits after the decimal point to be rounded
%
% OUTPUTS:
%
%       result                round-to-even result
%
%===================================================================================
% Created by: CHRIS D LARSON
% 01/18/2005
%
%===================================================================================
% Modified by: name
% mm/dd/yyyy
% Following modifications were made:
%
%===================================================================================

% check input arguements
if nargin<1,
    error('invalid input arguements.');
end
if nargin<2,
    Ndigits = 0; % default number of precision digits
end

% shift input by N digits to the left
x = x*10^(Ndigits);

result = zeros(size(x));
for k = 1:max(size(x)),
    if isequal(mod(floor(abs(x(k))),2),0)&isequal(abs(x(k)-floor(x(k))),0.5),
        result(k) = round(x(k)/2)*2;
    else
        result(k) = round(x(k));
    end
end

% shift output result by N digits to the right
result = result/10^(Ndigits);
