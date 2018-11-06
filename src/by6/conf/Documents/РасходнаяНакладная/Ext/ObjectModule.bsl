﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	Движения.Проводки.Записывать = Истина;
	
	// регистр Проводки
	Движение = Движения.Проводки.Добавить();
	Движение.СчетДт			 = ПланыСчетов.Управленческий.Покупатели;
	Движение.СчетКт			 = ПланыСчетов.Управленческий.ПрибылиУбытки;
	Движение.Период			 = Дата;
	Движение.ВалютаДт		 = Валюта;
	Движение.Сумма			 = Сумма * Курс;
	Движение.ВалютнаяСуммаДт = Сумма;
	Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Контрагенты]	 = Контрагент;
	Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Договоры]		 = Договор;
КонецПроцедуры
