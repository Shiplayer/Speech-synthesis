# Speech-synthesis
Ссылки:
- Matlib:
  * [Matlib Plot](http://www.mathworks.com/help/matlab/ref/plot.html?searchHighlight=plot)
  * [Matlib DFT](http://www.mathworks.com/help/matlab/math/discrete-fourier-transform-dft.html)
  * [Matlib FFT](http://www.mathworks.com/help/matlab/ref/fft.html)
- Habrahabr:
  * [Преобразование Фурье для анализа сигналов](https://m.habrahabr.ru/post/269991/)
  * [Распознавание речи](https://habrahabr.ru/post/226143/)
  * [Мел-кепстральные коэффициенты](https://habrahabr.ru/post/140828/)
- Другие ссылки:
  * [Структура WAV файла](http://audiocoding.ru/article/2008/05/22/wav-file-structure.html)
  * [MFCC Tutorial](http://www.practicalcryptography.com/miscellaneous/machine-learning/guide-mel-frequency-cepstral-coefficients-mfccs/)
- Возможно, новый [дата сет](http://www.manythings.org/audio/sentences/)

Проблемы, с которыми мы столкнулись:
* Странное воспроизведение аудиозаписи из дата сета (странный кусок аудиозаписи в конце)
* Определение слов и предлогов в аудиозаписи //Используем энтропию для точного определения
* Искажается аудиозапись при копировании и воспроизведении этого куска (при копировании, изменение данных не было обнаружено)
* Добавить наличие/отстуствие основного тона для слова (Принимает два значения 1 или 0 - есть/нет)//отправлять как фичу в сеть
* Добавить частоту основного тона //отправлять как фичу в сеть
* 
Если ничего не выйдет забить и сделать сеть для према целых предложений.
