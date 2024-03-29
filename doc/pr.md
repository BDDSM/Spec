# Заметки "Сложные периодические расчёты"

```
Метод отклонений = факт / план
```

Есть период действия, делится фактически отработанное время на плановое рабочее время.

Чтобы работал механизм вытеснений в плане видов расчёта требуется активировать опцию `Использует период действия`

Опция `Базовый период` в настройках РР включает механизмы получения суммы по базе.

При работе с периодическими расчётами обработка проведения строится в 3 этапа:
1. сохранение исходных данных (сохранение данных документа в регистр)
2. получение необходимых данных
3. расчёт результата

Фраза *"... могут вводиться в систему задним числом"* означает, что требуется организовать сторнирование.

Перерасчёт требуется, когда разные виды расчёта вводятся разными документами, и после изменения одного, требуется пересчитать другие связанные расчёты.

В обработке перерасчёта берётся таблица перерасчётов, группируется по документам, читается набор записей соответствующего документа, рассчитываются итоги по регистратору, затем отправляются записи в метод `РассчитатьРегистрыРасчета` (шаблонный метод общего модуля).

Когда добавляются записи, которые конфликтуют по периоду действия и регистрации (период регистрации больше, чем период действия), например, при вводе задним числом командировки, то требуется добавить в движения дополнительные сторно-записи из результата функции `ПолучитьДополнение()`.
