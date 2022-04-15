using UnityEngine;
using Votanic.vXR.vGear;

namespace Script.Game
{
    public class GearOnSelect : vGear_Interactables
    {
        public bool selected { private set; get; } = false;
        public Object data;

        void OnWandSelect()
        {
            selected = true;
        }

        void OnWandDeselect()
        {
            selected = false;
        }

    }
}
