﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	ВидСубконтоСклады		 = ПланыВидовХарактеристик.ВидыСубконто.Склады;
	ВидСубконтоНоменклатура	 = ПланыВидовХарактеристик.ВидыСубконто.Номенклатура;
	СчетТовары		 = ПланыСчетов.Управленческий.Товары;
	СчетПоставщики	 = ПланыСчетов.Управленческий.Поставщики;
	
	Движения.ОстаткиНоменклатуры.Записывать = Истина;
	Движения.Партии.Записывать = Истина;
	Движения.Проводки.Записывать = Истина;
	
	Движения.ОстаткиНоменклатуры.Очистить();
	Движения.Партии.Очистить();
	Движения.Проводки.Очистить();
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПриходнаяНакладнаяТовары.Номенклатура КАК Номенклатура,
		|	СУММА(ПриходнаяНакладнаяТовары.Количество) КАК Количество,
		|	СУММА(ПриходнаяНакладнаяТовары.Сумма) КАК Сумма
		|ИЗ
		|	Документ.ПриходнаяНакладная.Товары КАК ПриходнаяНакладнаяТовары
		|ГДЕ
		|	ПриходнаяНакладнаяТовары.Ссылка = &Ссылка
		|	И ПриходнаяНакладнаяТовары.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Товар)
		|
		|СГРУППИРОВАТЬ ПО
		|	ПриходнаяНакладнаяТовары.Номенклатура");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		// регистр ОстаткиНоменклатуры Приход
		Движение = Движения.ОстаткиНоменклатуры.ДобавитьПриход();
		Движение.Период			 = Дата;
		Движение.Номенклатура	 = Выборка.Номенклатура;
		Движение.Склад			 = Склад;
		Движение.Количество		 = Выборка.Количество;
		
		// регистр Партии Приход
		Движение = Движения.Партии.ДобавитьПриход();
		Движение.Период			 = Дата;
		Движение.Номенклатура	 = Выборка.Номенклатура;
		Движение.Партия			 = Ссылка;
		Движение.Количество		 = Выборка.Количество;
		Движение.Стоимость		 = Выборка.Сумма;
		
		// регистр Проводки
		Движение = Движения.Проводки.Добавить();
		Движение.Период								 = Дата;
		Движение.СчетДт								 = СчетТовары;
		Движение.СчетКт								 = СчетПоставщики;
		Движение.СубконтоДт[ВидСубконтоНоменклатура] = Выборка.Номенклатура;
		Движение.СубконтоДт[ВидСубконтоСклады]		 = Склад;
		Движение.Сумма								 = Выборка.Сумма;
		Движение.КоличествоДт						 = Выборка.Количество;
	КонецЦикла;
КонецПроцедуры
