﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	Движения.Проводки.Записывать = Истина;
	
	МВТ = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	РасходнаяНакладнаяТовары.Номенклатура КАК Номенклатура,
		|	РасходнаяНакладнаяТовары.Номенклатура.Представление КАК НоменклатураПредставление,
		|	СУММА(РасходнаяНакладнаяТовары.Количество) КАК Количество,
		|	СУММА(РасходнаяНакладнаяТовары.Сумма) КАК Сумма
		|ПОМЕСТИТЬ втТЧ
		|ИЗ
		|	Документ.РасходнаяНакладная.Товары КАК РасходнаяНакладнаяТовары
		|ГДЕ
		|	РасходнаяНакладнаяТовары.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	РасходнаяНакладнаяТовары.Номенклатура
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура");
	
	Запрос.МенеджерВременныхТаблиц = МВТ;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Выполнить();
	
	ТаблицаПартий = ПартионныйУчет.ТаблицаСписанияПартий(ЭтотОбъект, Склад, МВТ, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрПартий Из ТаблицаПартий Цикл
		Проводка = Движения.Проводки.Добавить();
		Проводка.Период			 = Дата;
		Проводка.СчетДт			 = ПланыСчетов.Управленческий.ПрибылиУбытки;
		Проводка.СчетКт			 = ПланыСчетов.Управленческий.Товары;
		Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура]	 = СтрПартий.Номенклатура;
		Проводка.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Склады]		 = Склад;
		Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура]	 = СтрПартий.Номенклатура;
		Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Склады]		 = Склад;
		Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Партии]		 = СтрПартий.Партия;
		Проводка.КоличествоКт	 = СтрПартий.Количество;
		Проводка.Сумма			 = СтрПартий.Сумма;
		
		Если СтрПартий.Выручка = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Проводка = Движения.Проводки.Добавить();
		Проводка.Период			 = Дата;
		Проводка.СчетДт			 = ПланыСчетов.Управленческий.Покупатели;
		Проводка.СчетКт			 = ПланыСчетов.Управленческий.ПрибылиУбытки;
		Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура]	 = СтрПартий.Номенклатура;
		Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Склады]		 = Склад;
		Проводка.Сумма			 = СтрПартий.Выручка;
	КонецЦикла;
КонецПроцедуры
