load('../results.mat')

confusion_fig = figure('Units', 'inches', 'Position', [2 2 6 3.5]);
t = tiledlayout(confusion_fig, 1, 2);

nexttile
row_confusion = confusionchart(results('total').PerRow, {'Non-insect', 'Insect'});
row_confusion.FontSize = 12;
row_confusion.OffDiagonalColor = '#fb9a99';
%row_confusion.OffDiagonalColor = '#1f78b4';
row_confusion.DiagonalColor = '#b2df8a';
sortClasses(row_confusion, {'Non-insect', 'Insect'});
title('Per row')

nexttile
image_confusion = confusionchart(results('total').PerImage, {'Non-insect', 'Insect'});
image_confusion.FontSize = 12;
image_confusion.OffDiagonalColor = '#fb9a99';
%image_confusion.OffDiagonalColor = '#1f78b4';
image_confusion.DiagonalColor = '#b2df8a';
sortClasses(image_confusion, {'Non-insect', 'Insect'});
title('Per image')

exportgraphics(confusion_fig, 'confusion.pdf', 'ContentType', 'vector');
