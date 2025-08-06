package com.caitlinash.skillbridge_api;

import org.springframework.boot.SpringApplication;

public class TestSkillBridgeApplication {

	public static void main(String[] args) {
		SpringApplication.from(SkillBridgeApplication::main).with(TestcontainersConfiguration.class).run(args);
	}

}
