﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Проводки = Движения.Проводки;
	Проводки.Записывать = Истина;
	Если НЕ Проводки.Модифицированность() И НЕ ЭтоНовый() Тогда
		Проводки.Прочитать();
	КонецЕсли;
	
	ИзменитьАктивность = НЕ ЭтоНовый() И ПометкаУдаления <> Ссылка.ПометкаУдаления;
	
	Для Каждого Проводка Из Проводки Цикл
		Проводка.Период = Дата;
		
		Если ИзменитьАктивность Тогда
			Проводка.Активность = НЕ Проводка.Активность;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры
