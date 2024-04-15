% Intro to Bio-infromatics Final Project - text assembler 

clear all;

Original = "A Fox one day spied a beautiful bunch of ripe grapes hanging from a vine trained along the branches of a tree. The grapes seemed ready to burst with juice, and the Fox's mouth watered as he gazed longingly at them. The bunch hung from a high branch, and the Fox had to jump for it. The first time he jumped he missed it by a long way. So he walked off a short distance and took a running leap at it, only to fall short once more. Again and again he tried, but in vain. Now he sat down and looked at the grapes in disgust.";
n = strlength(Original);

NumberOfPieces = 50; % Select desired number of pieces/reads


[reads,readLength] = MakePieces(Original,n,NumberOfPieces);

SortedReads = SortLong(reads);

Longest = "";
for i = 1:NumberOfPieces
    [Longest,SortedReads] = AlignLongest(Longest,SortedReads,NumberOfPieces);

    SortedReads = SortLong(SortedReads);
end

Alignment = Longest;

Original
Alignment

function [reads,readLength] = MakePieces(Original,n,NumberOfPieces)
    i = 1;
    while i<(NumberOfPieces+1)
        num1 = randi(n);
        num2 = randi(n);
        if num1 > num2  % make sure num1 is the smallest of the 2 random numbers
            hold = num2;
            num2 = num1;
            num1 = hold;
        end

        if (num2-num1)>(n/2) % Cap maximum read size to = (original's size)/x
            num2=num1+round(n/4); % Change this one as well, same x
        end
        reads(i,1) = extractBetween(Original,num1,num2); % column vector, easier to read
        % ------ If i decide to add typos to the reads, do it here ---------%
        readLength(i,1) = strlength(reads(i,1));
        i = i + 1;
    end
end

function SortedtReads = SortLong(reads)
    [~,idx] = sort(cellfun('length', cellstr(reads)),1,"descend");
    SortedtReads = reads(idx,:);
end

function [Longest,SortedReads] = AlignLongest(Longest,SortedReads,NumberOfPieces)
if Longest == ""
Longest = SortedReads(1,1);
SortedReads(1,1) = "";
end
size = strlength(Longest);
PatternPosLeft = round(size/6);                % Select pattern size here
PatternPosRight = round(size-PatternPosLeft);
PatternLeft = extractBefore(Longest,PatternPosLeft);
PatternRight = extractAfter(Longest,PatternPosRight);

    for i = 1:(NumberOfPieces-1)  % Find Match to the right    
        if SortedReads(i,1)==Longest % make sure we don't compare longest read to itself
           continue
        elseif i > NumberOfPieces    % Break loop if we exceed # of reads (band aid fix)
            break
        end

        a = contains(SortedReads(i,1),PatternRight);
        if a==1
            MatchRight = extractAfter(SortedReads(i,1),PatternRight);
            Longest = strcat(Longest,MatchRight);
            SortedReads(i,1) = "";
            break
        end
    end

    for i = 1:(NumberOfPieces-1)  % Find Match to the Left    
        if SortedReads(i,1)==Longest % make sure we don't compare longest read to itself
           continue
        elseif i > NumberOfPieces    % Break loop if we exceed # of reads (band aid fix)
            break
        end

        a = contains(SortedReads(i,1),PatternLeft);
        if a==1
            MatchLeft = extractBefore(SortedReads(i,1),PatternLeft);
            Longest = strcat(MatchLeft,Longest);
            SortedReads(i,1) = "";
            break
        end
    end

end
