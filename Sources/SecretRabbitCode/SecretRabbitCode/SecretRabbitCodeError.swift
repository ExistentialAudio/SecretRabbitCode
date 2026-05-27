//
//  SecretRabbitCodeError.swift
//  SecretRabbitCode
//
//  Created by Devin Roth on 2026-05-26.
//
internal import CSamplerate

enum SecretRabbitCodeError: Error, Equatable {
    case InitalizationFailed(description: String)
    case ConversionFailed(description: String)
    case unusedInputFrames
}
