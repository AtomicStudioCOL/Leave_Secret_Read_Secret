/*

    Copyright (c) 2024 Pocketz World. All rights reserved.

    This is a generated file, do not edit!

    Generated by com.pz.studio
*/

#if UNITY_EDITOR

using System;
using System.Linq;
using UnityEngine;
using Highrise.Client;

namespace Highrise.Lua.Generated
{
    [AddComponentMenu("Lua/SentFeedback")]
    [LuaBehaviourScript(s_scriptGUID)]
    public class SentFeedback : LuaBehaviourThunk
    {
        private const string s_scriptGUID = "ce5d1b56f0deced4087635fca05390ff";
        public override string ScriptGUID => s_scriptGUID;


        protected override SerializedPropertyValue[] SerializeProperties()
        {
            if (_script == null)
                return Array.Empty<SerializedPropertyValue>();

            return new SerializedPropertyValue[]
            {
                CreateSerializedProperty(_script.GetPropertyAt(0), null),
                CreateSerializedProperty(_script.GetPropertyAt(1), null),
            };
        }
    }
}

#endif